// DB Service

using Microsoft.EntityFrameworkCore;
using DBService;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using System.Text;
using System.Collections.Generic;
using System.Data;
using System.Data.OleDb;
using System.Data.SqlClient;
using System.Linq;
using System;
StreamWriter writer;
string logFPath = Path.Combine(Directory.GetCurrentDirectory(), "DBCommunication.log");



var dbHost = Environment.GetEnvironmentVariable("DB_HOST"); 
var dbName = Environment.GetEnvironmentVariable("DB_NAME");
var dbPassword = Environment.GetEnvironmentVariable("DB_SA_PASSWORD");
var connectionString = $"Data Source={dbHost};Initial Catalog={dbName};User ID=sa;Password={dbPassword};TrustServerCertificate=True;Encrypt=True;";
var optionsBuilder = new DbContextOptionsBuilder<CheckersDBContext>();
optionsBuilder.UseSqlServer(connectionString);
using var context = new CheckersDBContext(optionsBuilder.Options);


const string hostIP = "172.20.0.1";
const int hostPort = 5672;
const string exchangeName = "checkers";

const string db_add_key = "db_add_data";
const string db_sample_key = "db_sample_data";
const string db_update_key = "db_update_data";
const string db_remove_key = "db_remove_data";

const string move_service_key = "move_service";
const string game_inst_inf_key = "game_inst_inf";

const string ident_service_key = "ident_service";
const string game_server_key = "game_server";
const string log_key = "log";

const string rabbitName = "rabbitmq";

var factory = new ConnectionFactory { HostName = rabbitName, Port = hostPort};

using var connection = await factory.CreateConnectionAsync();
using var channel = await connection.CreateChannelAsync();

await channel.ExchangeDeclareAsync(exchange: exchangeName, type: ExchangeType.Direct);

var queueDeclareResult = await channel.QueueDeclareAsync();
string queueName = queueDeclareResult.QueueName;

await channel.QueueBindAsync(queue: queueName, exchange: exchangeName, routingKey: db_add_key);
await channel.QueueBindAsync(queue: queueName, exchange: exchangeName, routingKey: db_sample_key);
await channel.QueueBindAsync(queue: queueName, exchange: exchangeName, routingKey: db_update_key);


var consumer = new AsyncEventingBasicConsumer(channel);
consumer.ReceivedAsync += (model, ea) =>
{

    var routingKey = ea.RoutingKey;
    byte[] body = ea.Body.ToArray();
    var message = Encoding.UTF8.GetString(body);
    string[] messData = message.Split(',');
    string senderKey = messData[0];


    string returnMessage = "";

    if (routingKey == db_add_key)
    {
        if (senderKey == move_service_key)
        {
            channel.BasicPublishAsync(exchange: exchangeName, routingKey: log_key, body: Encoding.UTF8.GetBytes("Move log in DB attempt:" + "\n" + Environment.NewLine + Environment.NewLine));
            logFunc("Move log in DB attempt");

            const int numsCount = 6;
            int[] nums = new int[numsCount];
            for (int i = 1; i < messData.Length && i - 1 < numsCount; i++)
            {
                if (int.TryParse(messData[i], out int number))
                {
                    nums[i - 1] = number;
                }
                else
                {
                    //writer.WriteLine($"Can not be parsed: {messData[i]}"); 
                }

            }
            int GameId;
            if (!int.TryParse(messData[7], out GameId))
            {
                GameId = 1;
            }

            var moveRecord = new DBService.Models.GameMove
            {
                GameId = GameId, 
                PlayerId = nums[1], 
                xStart = (byte)nums[2],
                yStart = (byte)nums[3],
                xEnd = (byte)nums[4],
                yEnd = (byte)nums[5],
                moveCode = nums[0],
                MoveTimestamp = DateTime.Now.AddHours(3)
            };
            try
            {
                context.Moves.Add(moveRecord);
                object val = context.SaveChanges();
                channel.BasicPublishAsync(exchange: exchangeName, routingKey: log_key, body: Encoding.UTF8.GetBytes("Move log in DB succesefull added:" + "\n" + Environment.NewLine + Environment.NewLine));
                logFunc("Move log in DB succesefull added");

                returnMessage = string.Format("{0},{1}", db_add_key, 0);

            }
            catch (Exception ex)
            {
                channel.BasicPublishAsync(exchange: exchangeName, routingKey: log_key, body: Encoding.UTF8.GetBytes("Move log in DB adding error " + ex + "\n" + Environment.NewLine + Environment.NewLine));
                logFunc("Move log in DB adding error");

                returnMessage = string.Format("{0},{1}", db_add_key, 1);
            }
        }
        else if (senderKey == game_inst_inf_key)
        {
            channel.BasicPublishAsync(exchange: exchangeName, routingKey: log_key, body: Encoding.UTF8.GetBytes("Add game info in DB attempt:" + "\n" + Environment.NewLine + Environment.NewLine));
            logFunc("Add game info in DB attempt");

            const int numsCount = 2;
            int[] nums = new int[numsCount];
            DateTime timeInfo;
            for (int i = 1; i < messData.Length && i < numsCount + 1; i++)
            {
                if (int.TryParse(messData[i], out int number))
                {
                    nums[i - 1] = number;
                }
                else
                {
                   //writer.WriteLine($"Can not be parsed: {messData[i]}"); 
                }

            }
            if (!DateTime.TryParse(messData[3], out timeInfo))
            {
               // writer.WriteLine($"Can not be parsed: {messData[3]}");
            }


            //Создание записи для БД
            var gameRecord = new DBService.Models.Game
            {
                Player1Id = nums[0],
                Player2Id = nums[1],
                StartTime = timeInfo
            };
            try
            {
                context.Games.Add(gameRecord);
                object val = context.SaveChanges();
                channel.BasicPublishAsync(exchange: exchangeName, routingKey: log_key, body: Encoding.UTF8.GetBytes("Game info in DB succesefull added:" + "\n" + Environment.NewLine + Environment.NewLine));
                logFunc("Game info in DB succesefull added");

                // 0 - success, 1 - error
                returnMessage = string.Format("{0},{1},{2}", db_add_key, 0, gameRecord.Id);

            }
            catch (Exception ex)
            {
                channel.BasicPublishAsync(exchange: exchangeName, routingKey: log_key, body: Encoding.UTF8.GetBytes("Game info in DB adding error:" + "\n" + Environment.NewLine + Environment.NewLine));
                logFunc("Game info in DB adding error");

                returnMessage = string.Format("{0},{1},", db_add_key, 1);
            }
        }
        else if (senderKey == ident_service_key)
        {
            channel.BasicPublishAsync(exchange: exchangeName, routingKey: log_key, body: Encoding.UTF8.GetBytes("Add user data in DB attempt for registration:" + "\n" + Environment.NewLine + Environment.NewLine));
            logFunc("Add user data in DB attempt for registration");

            string answStr = db_add_key + ",";
            bool exists = context.Users.Any(record => record.UserName == messData[1]);

            if (exists)
            {
                channel.BasicPublishAsync(exchange: exchangeName, routingKey: log_key, body: Encoding.UTF8.GetBytes("Authorization error: This login already exists" + "\n" + Environment.NewLine + Environment.NewLine));
                logFunc("Authorization error: This login already exists");

                answStr += "fail,This login already exists,";
            }
            else
            {
                var userRecord = new DBService.Models.User
                {
                    UserName = messData[1],
                    PasswordHash = messData[2],
                    RegistrDate = DateTime.Now.AddHours(3)
                };

                try
                {
                    context.Users.Add(userRecord);
                    object val = context.SaveChanges();
                    channel.BasicPublishAsync(exchange: exchangeName, routingKey: log_key, body: Encoding.UTF8.GetBytes("User data in DB successfuly added for registration:" + "\n" + Environment.NewLine + Environment.NewLine));
                    logFunc("User data in DB successfuly added for registration");

                    var record = context.Users.FirstOrDefault(record => record.UserName == messData[1]);
                    string userId = record.Id.ToString();


                    answStr += "ok,Successful registration," + userId;

                }
                catch (Exception ex)
                {
                    channel.BasicPublishAsync(exchange: exchangeName, routingKey: log_key, body: Encoding.UTF8.GetBytes("User data adding in DB for registration error:" + "\n" + Environment.NewLine + Environment.NewLine));
                    logFunc("User data adding in DB for registration error");

                    answStr += "fail,Registration problem: data saving error - try to register again,";
                }

            }
            returnMessage = answStr;
        }
    }
    else if (routingKey == db_sample_key)
    {
        if (senderKey == ident_service_key)
        {
            channel.BasicPublishAsync(exchange: exchangeName, routingKey: log_key, body: Encoding.UTF8.GetBytes("Authorization attempt:" + "\n" + Environment.NewLine + Environment.NewLine));
            logFunc("Authorization attempt");

            string answStr = db_sample_key + ",";
            var record = context.Users.FirstOrDefault(record => record.UserName == messData[1]);

            if (record == null)
            {
                channel.BasicPublishAsync(exchange: exchangeName, routingKey: log_key, body: Encoding.UTF8.GetBytes("Authorization error: invalid username or password" + "\n" + Environment.NewLine + Environment.NewLine));
                logFunc("Authorization error: invalid username or password");

                answStr += "fail,Authorization error: invalid username or password,";
            }
            else
            {
                if (record.PasswordHash != messData[2])
                {
                    channel.BasicPublishAsync(exchange: exchangeName, routingKey: log_key, body: Encoding.UTF8.GetBytes("Authorization error: invalid username or password" + "\n" + Environment.NewLine + Environment.NewLine));
                    logFunc("Authorization error: invalid username or password");

                    answStr += "fail,Authorization error: invalid username or password,";
                }
                else
                {
                    string userId = record.Id.ToString();
                    answStr += "ok,Successful authorization," + userId;

                }
            }
            returnMessage = answStr;
        }
        else if (senderKey == game_server_key)
        {
            channel.BasicPublishAsync(exchange: exchangeName, routingKey: log_key, body: Encoding.UTF8.GetBytes("Request for games data:" + "\n" + Environment.NewLine + Environment.NewLine));
            logFunc("Request for games data");

            string resultMessage = "gameInfo, ";
            int id;
            if (!int.TryParse(messData[1], out id))
            {
                id = 0;
            }
            var games1 = context.Games.Where(e => e.Player1Id == id).ToList();
            var games2 = context.Games.Where(e => e.Player2Id == id).ToList();
            foreach ( var game in games1)
            {
                resultMessage += "Games id: " + game.Id.ToString() +
                " first players id: " + game.Player1Id.ToString() +
                " second players id: " + game.Player2Id.ToString() +
                (game.IsInterrupted ? " game was interrupted" : " winner id: " + game.WinnerId.ToString()) +
                 Environment.NewLine;
            }
            foreach (var game in games2)
            {
                resultMessage += "Games id: " + game.Id.ToString() +
                " first players id: " + game.Player1Id.ToString() +
                " second players id: " + game.Player2Id.ToString() +
                (game.IsInterrupted ? " game was interrupted" : " winner id: " + game.WinnerId.ToString()) +
                 Environment.NewLine;
            }
            returnMessage = resultMessage;
            channel.BasicPublishAsync(exchange: exchangeName, routingKey: log_key, body: Encoding.UTF8.GetBytes("Request for games data result:" + resultMessage + "\n" + Environment.NewLine + Environment.NewLine));
            logFunc("Request for games data result:" + resultMessage);

        }
    }
    else if (routingKey == db_update_key)
    {
        if (senderKey == game_inst_inf_key) 
        {
            channel.BasicPublishAsync(exchange: exchangeName, routingKey: log_key, body: Encoding.UTF8.GetBytes("Request for update game info after finish:" + "\n" + Environment.NewLine + Environment.NewLine));
            logFunc("Request for update game info after finish");

            int gameId;
            if (!int.TryParse(messData[1], out gameId))
            {
                gameId = 0;
            }
            var record = context.Games.FirstOrDefault(r => r.Id == gameId);
            if(record != null)
            {
                int flagVal;
                if (!int.TryParse(messData[4], out flagVal))
                {
                    flagVal = 0;
                }
                if (flagVal == 1)
                {
                    record.IsInterrupted = true;
                }
                else
                {
                    int winner;
                    if(!int.TryParse(messData[3], out winner))
                    {
                        winner = 0;
                    }
                    record.WinnerId = winner;
                    record.IsInterrupted = false;
                }
                DateTime endTime;
                if (!DateTime.TryParse(messData[2], out endTime))
                {
                    endTime = DateTime.Now.AddHours(3);
                }
                record.EndTime = endTime;

                try {
                    context.SaveChanges();
                    channel.BasicPublishAsync(exchange: exchangeName, routingKey: log_key, body: Encoding.UTF8.GetBytes("Success updating game info after finish" + "\n" + Environment.NewLine + Environment.NewLine));
                    logFunc("Success updating game info after finish");

                }
                catch
                {
                    channel.BasicPublishAsync(exchange: exchangeName, routingKey: log_key, body: Encoding.UTF8.GetBytes("Request for update game info after finish error adding in DB" + "\n" + Environment.NewLine + Environment.NewLine));
                    logFunc("Request for update game info after finish error adding in DB");

                }
            }
           
        }
    }
    else if (routingKey == db_remove_key)
    {

    }


    var returnBody = Encoding.UTF8.GetBytes(returnMessage);
    
    channel.BasicPublishAsync(exchange: exchangeName, routingKey: senderKey, body: returnBody);

    return Task.CompletedTask;
};

await channel.BasicConsumeAsync(queueName, autoAck: true, consumer: consumer);

Console.WriteLine(" Press [enter] to exit.");
Console.ReadLine();



void logFunc(string str)
{

    lock (LockManager.FileLock)
    {
        using (var writer = new StreamWriter(logFPath, append: true))
        {
            writer.WriteLine(str + "\n");
            writer.Flush();

        }
    }

}



static class LockManager
{
    public static readonly object FileLock = new object();
}