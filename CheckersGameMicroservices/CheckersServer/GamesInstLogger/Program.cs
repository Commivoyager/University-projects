// GAME_INST logger

using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using System.Text;

const string hostIP = "172.20.0.1";
const int hostPort = 5672;
const string exchangeName = "checkers";
const string game_instnc_key = "game_instnc";
const string logFPath = "GameInst.log";

using var writer = new StreamWriter(logFPath, append: true);

const string rabbitName = "rabbitmq";
var factory = new ConnectionFactory { HostName = rabbitName, Port = hostPort};

using var connection = await factory.CreateConnectionAsync();
using var channel = await connection.CreateChannelAsync();

await channel.ExchangeDeclareAsync(exchange: exchangeName, type: ExchangeType.Direct);

var queueDeclareResult = await channel.QueueDeclareAsync();
string queueName = queueDeclareResult.QueueName;
await channel.QueueBindAsync(queue: queueName, exchange: exchangeName, routingKey: game_instnc_key);


Console.WriteLine("Waiting for game instance logs");

var consumer = new AsyncEventingBasicConsumer(channel);
consumer.ReceivedAsync += (model, ea) =>
{
    byte[] body = ea.Body.ToArray();
    var message = Encoding.UTF8.GetString(body);
    Console.WriteLine($"Console:  {message}");

    writer.WriteLine(message);
    return Task.CompletedTask;
};

await channel.BasicConsumeAsync(queueName, autoAck: true, consumer: consumer);

Console.WriteLine(" Press [enter] to exit.");
Console.ReadLine();


Console.WriteLine("Program instance");
