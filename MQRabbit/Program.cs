using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using System;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;

namespace MQRabbit
{
    public class Email
    {
        public string ToAddress { get; set; }
        public string EmailSubject { get; set; }
        public string EmailBody { get; set; }
    }

    public class EmailSender
    {
        private readonly SmtpClient _smtpClient;
        private readonly string _defaultSender;

        public EmailSender()
        {
            var serverAddress = Environment.GetEnvironmentVariable("SERVER_ADDRESS") ?? "smtp.gmail.com";
            var senderAddress = Environment.GetEnvironmentVariable("MAIL_SENDER") ?? "musicshop225883@gmail.com";
            var senderPassword = Environment.GetEnvironmentVariable("MAIL_PASS") ?? "prnkhviwmogxbfyj";
            var port = int.Parse(Environment.GetEnvironmentVariable("MAIL_PORT") ?? "587");

            _defaultSender = senderAddress;

            _smtpClient = new SmtpClient(serverAddress, port)
            {
                Credentials = new NetworkCredential(senderAddress, senderPassword),
                EnableSsl = true
            };
        }

        public void Send(Email email)
        {
            var mailMessage = new MailMessage
            {
                From = new MailAddress(_defaultSender),
                Subject = email.EmailSubject,
                Body = $"<p>{email.EmailBody}</p>",
                IsBodyHtml = true
            };

            mailMessage.To.Add(new MailAddress(email.ToAddress));

            try
            {
                Console.WriteLine("Sending email...");
                _smtpClient.Send(mailMessage);
                Console.WriteLine("Email sent successfully.");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Failed to send email: {ex.Message}");
            }
        }
    }

    public class RabbitMqListener
    {
        private readonly EmailSender _emailSender;

        public RabbitMqListener(EmailSender emailSender)
        {
            _emailSender = emailSender;
        }

        public void StartListening()
        {
            var hostname = Environment.GetEnvironmentVariable("RABBITMQ_HOST") ?? "localhost";
            var username = Environment.GetEnvironmentVariable("RABBITMQ_USER") ?? "guest";
            var password = Environment.GetEnvironmentVariable("RABBITMQ_PASS") ?? "guest";

            var factory = new ConnectionFactory
            {
                HostName = hostname,
                UserName = username,
                Password = password
            };

            using var connection = factory.CreateConnection();
            using var channel = connection.CreateModel();

            channel.QueueDeclare(
                queue: "email.create",
                durable: false,
                exclusive: false,
                autoDelete: false,
                arguments: null
            );

            Console.WriteLine("Waiting for messages...");

            var consumer = new EventingBasicConsumer(channel);

            consumer.Received += (model, ea) =>
            {
                var body = ea.Body.ToArray();
                var messageJson = Encoding.UTF8.GetString(body);
                var email = JsonConvert.DeserializeObject<Email>(messageJson);

                if (email != null)
                {
                    _emailSender.Send(email);
                }
            };

            channel.BasicConsume(
                queue: "email.create",
                autoAck: true,
                consumer: consumer
            );

            Task.Delay(-1).Wait();
        }
    }

    class EntryPoint
    {
        static void Main(string[] args)
        {
            var emailSender = new EmailSender();
            var listener = new RabbitMqListener(emailSender);
            listener.StartListening();
        }
    }
}
