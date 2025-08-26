// Game server
using CheckersServer;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using System.Threading.Tasks;
using System.Text;

Server server = null;

//StreamWriter writer;
string logFPath = Path.Combine(Directory.GetCurrentDirectory(), "GameServer.log");

//RabbitMQ
var factory = new ConnectionFactory {
    HostName= Server.rabbitName,
    Port = Server.brockerPort,
    UserName = "guest",
    Password = "guest",
    VirtualHost ="/",

}; 
using var connection = await factory.CreateConnectionAsync();

await Task.Delay(5000);

using RabbitMQ.Client.IChannel channel = await connection.CreateChannelAsync();
await channel.ExchangeDeclareAsync(exchange: Server.exchangeName/*"checkers"*/, type: ExchangeType.Direct);

var queueDeclareResult = await channel.QueueDeclareAsync();
string queueName = queueDeclareResult.QueueName;
await channel.QueueBindAsync(queue: queueName, exchange: Server.exchangeName, routingKey: Server.game_inst_inf_key);
await channel.QueueBindAsync(queue: queueName, exchange: Server.exchangeName, routingKey: Server.ident_service_key);
await channel.QueueBindAsync(queue: queueName, exchange: Server.exchangeName, routingKey: Server.game_server_key);


var consumer = new AsyncEventingBasicConsumer(channel);
consumer.ReceivedAsync += (model, ea) =>
{
    var routingKey = ea.RoutingKey;
    byte[] body = ea.Body.ToArray();
    var message = Encoding.UTF8.GetString(body);
    string[] messData = message.Split(',');
    string senderKey = messData[0];

    if(senderKey == Server.db_add_key)
    {
        if(routingKey == Server.game_inst_inf_key)
        {
            int operationRes;
            if (int.TryParse(messData[1], out operationRes))
            {
                if(operationRes == 0)
                {
                    int gameId;
                    if (int.TryParse(messData[2], out gameId))
                    {
                        Server.GameId = gameId;
                    }
                    else
                    {
                        Server.GameId = 1;
                    }
                }
                else
                {
                    Server.GameId = 1;
                }
            }
        }else if(routingKey == Server.ident_service_key || senderKey == Server.db_sample_key)
        {
            server.authAnsw = "," + messData[2] + ",";

            if(messData[1] == "ok")
            {
                server.isAuthSuccess = true;
                server.authAnsw += messData[3] + ",";
            }
            else
            {
                server.isAuthSuccess = false;
            }
            server.identActDone = true;
        }
    }else if(senderKey == Server.db_sample_key)
    {
        server.authAnsw = "," + messData[2] + ",";

        if (messData[1] == "ok")
        {
            server.isAuthSuccess = true;
            server.authAnsw += messData[3] + ",";
        }
        else
        {
            server.isAuthSuccess = false;
        }
        server.identActDone = true;
    }else if(senderKey == "gameInfo")
    {
        server.allGamesData = messData[1];
        server.gamesDataReceived = true;
    }




    return Task.CompletedTask;

};
await channel.BasicConsumeAsync(queueName, autoAck: true, consumer: consumer);


server = new Server(channel);
//server.ConnectPlayers();

channel.BasicPublishAsync(exchange: Server.exchangeName, routingKey: Server.log_key, body: Encoding.UTF8.GetBytes("Players connection with server started"+"\n"+Environment.NewLine+Environment.NewLine));
logFunc("Players connection with server started");

server.ConnectPlayers();
channel.BasicPublishAsync(exchange: Server.exchangeName, routingKey: Server.log_key, body: Encoding.UTF8.GetBytes("Players connection with server finished. Authorization started" + "\n" + Environment.NewLine + Environment.NewLine));
logFunc("Players connection with server finished. Authorization started");

server.AuthorizeUsers();

while (true)
{
    channel.BasicPublishAsync(exchange: Server.exchangeName, routingKey: Server.log_key, body: Encoding.UTF8.GetBytes("Players authorization with server finished" + "\n" + Environment.NewLine + Environment.NewLine));
    logFunc("Players authorization with server finished");

    server.startCommunication();
    channel.BasicPublishAsync(exchange: Server.exchangeName, routingKey: Server.log_key, body: Encoding.UTF8.GetBytes("Game started" + "\n" + Environment.NewLine + Environment.NewLine));
    logFunc("Game started");

    server.serverCommunication();
    int DEBUG = 0;
}

void logFunc(string str)
{
    lock (Server.fileLock)
    {
        using (var writer = new StreamWriter(logFPath, append: true))
        {
            writer.WriteLine(str + "\n");
            writer.Flush();

        }
    }

}