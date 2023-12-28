using Microsoft.EntityFrameworkCore;
using MusicShop.Services;
using MusicShop.Services.Database;
using MusicShop.Services.Implementations;
using MusicShop.Services.Interfaces;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddAutoMapper(typeof(MappingProfile));

builder.Services.AddTransient<IBrandService, BrandService>();
builder.Services.AddTransient<IGuitarService, GuitarService>();
builder.Services.AddTransient<IAmplifierService, AmplifierServivce>();
builder.Services.AddTransient<IBassService, BassService>();
builder.Services.AddTransient<ISynthesizerService, SynthesizerService>();
builder.Services.AddTransient<IGearCategoryService, GearCategoryService>();
builder.Services.AddTransient<IGearService, GearService>();

var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
builder.Services.AddDbContext<MusicShopDBContext>(options =>
    options.UseSqlServer(connectionString));

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
