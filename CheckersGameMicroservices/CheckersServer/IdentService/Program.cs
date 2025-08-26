// IdentService
using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using System.Text;

var logFPath = Path.Combine(Directory.GetCurrentDirectory(), "Project.log");
StreamWriter writer;
const string hostIP = "172.20.0.1";
const int hostPort = 5672;
const string exchangeName = "checkers";

const string ident_service_key = "ident_service";
const string move_service_key = "move_service";
const string game_inst_inf_key = "game_inst_inf";
const string game_server_key = "game_server";
const string db_add_key = "db_add_data";
const string db_sample_key = "db_sample_data";
const string db_update_key = "db_update_data";
const string db_remove_key = "db_remove_data";
const string log_key = "log";



const string rabbitName = "rabbitmq";

var factory = new ConnectionFactory { HostName = rabbitName, Port = hostPort};

using var connection = await factory.CreateConnectionAsync();
using var channel = await connection.CreateChannelAsync();

await channel.ExchangeDeclareAsync(exchange: exchangeName, type: ExchangeType.Direct);

var queueDeclareResult = await channel.QueueDeclareAsync();
string queueName = queueDeclareResult.QueueName;
await channel.QueueBindAsync(queue: queueName, exchange: exchangeName, routingKey: log_key);
await channel.QueueBindAsync(queue: queueName, exchange: exchangeName, routingKey: ident_service_key);
await channel.QueueBindAsync(queue: queueName, exchange: exchangeName, routingKey: db_add_key);
await channel.QueueBindAsync(queue: queueName, exchange: exchangeName, routingKey: db_sample_key);
await channel.QueueBindAsync(queue: queueName, exchange: exchangeName, routingKey: db_update_key);
await channel.QueueBindAsync(queue: queueName, exchange: exchangeName, routingKey: game_inst_inf_key);
await channel.QueueBindAsync(queue: queueName, exchange: exchangeName, routingKey: game_server_key);


var consumer = new AsyncEventingBasicConsumer(channel);
consumer.ReceivedAsync += (model, ea) =>
{
    byte[] body = ea.Body.ToArray();
    var message = Encoding.UTF8.GetString(body);

    writer = new StreamWriter(logFPath, append: true);
    try
    {
        lock (writer)
        {
            writer.WriteLine(message+"\n"+Environment.NewLine+Environment.NewLine);
            writer.Flush();
        }
    }
    catch (Exception ex)
    {
        Console.WriteLine($"Error writing to file: {ex.Message}");
    }

    writer.Close();

    return Task.CompletedTask;
};

await channel.BasicConsumeAsync(queueName, autoAck: true, consumer: consumer);

