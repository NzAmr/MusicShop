using MusicShop.Model;
using MusicShop.Services.Interfaces;
using Newtonsoft.Json;
using RabbitMQ.Client;
using System;
using System.Text;

namespace MusicShop.Services.Implementations
{
    public class RabbitMQService : IRabbitMQService
    {
        private readonly ConnectionFactory _connectionFactory;

        public RabbitMQService()
        {
            _connectionFactory = CreateConnectionFactory();
        }

        private static ConnectionFactory CreateConnectionFactory()
        {
            var host = Environment.GetEnvironmentVariable("RABBITMQ_HOST") ?? "localhost";
            var user = Environment.GetEnvironmentVariable("RABBITMQ_USER") ?? "guest";
            var pass = Environment.GetEnvironmentVariable("RABBITMQ_PASS") ?? "guest";

            return new ConnectionFactory
            {
                HostName = host,
                UserName = user,
                Password = pass
            };
        }

        public void sendEmail(Mail mail)
        {
            using var connection = _connectionFactory.CreateConnection();
            using var channel = connection.CreateModel();

            SetupQueue(channel);

            var messageBytes = ConvertMailToBytes(mail);

            PublishToQueue(channel, messageBytes);
        }

        private static void SetupQueue(IModel channel)
        {
            channel.QueueDeclare(
                queue: "email.create",
                durable: false,
                exclusive: false,
                autoDelete: false,
                arguments: null);
        }

        private static byte[] ConvertMailToBytes(Mail mail)
        {
            var mailJson = JsonConvert.SerializeObject(mail);
            return Encoding.UTF8.GetBytes(mailJson);
        }

        private static void PublishToQueue(IModel channel, byte[] messageBytes)
        {
            channel.BasicPublish(
                exchange: string.Empty,
                routingKey: "email.create",
                basicProperties: null,
                body: messageBytes);
        }
    }
}
