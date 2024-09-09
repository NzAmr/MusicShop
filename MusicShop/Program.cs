using Microsoft.AspNetCore.Authentication;
using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Models;
using MusicShop;
using MusicShop.Services;
using MusicShop.Services.Database;
using MusicShop.Services.Implementations;
using MusicShop.Services.Interfaces;
using MusicShop.Services.StudioStateMachine;

var builder = WebApplication.CreateBuilder(args);



builder.Services.AddControllers();

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.AddSecurityDefinition("basicAuth", new Microsoft.OpenApi.Models.OpenApiSecurityScheme()
    {
        Type = Microsoft.OpenApi.Models.SecuritySchemeType.Http,
        Scheme = "basic"
    });

    c.AddSecurityRequirement(new Microsoft.OpenApi.Models.OpenApiSecurityRequirement()
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference{Type = ReferenceType.SecurityScheme, Id = "basicAuth"}
            },
            new string[]{}
    } });

});

builder.Services.AddAutoMapper(typeof(MappingProfile));

builder.Services.AddTransient<IBrandService, BrandService>();
builder.Services.AddTransient<IGuitarService, GuitarService>();
builder.Services.AddTransient<IAmplifierService, AmplifierServivce>();
builder.Services.AddTransient<IBassService, BassService>();
builder.Services.AddTransient<ISynthesizerService, SynthesizerService>();
builder.Services.AddTransient<IGearCategoryService, GearCategoryService>();
builder.Services.AddTransient<IGearService, GearService>();
builder.Services.AddTransient<IShippingInfoService, ShippingInfoService>();
builder.Services.AddTransient<ICustomerService, CustomerService>();
builder.Services.AddTransient<IEmployeeService, EmployeeService>();
builder.Services.AddTransient<IGuitarTypeService, GuitarTypeService>();
builder.Services.AddTransient<IProductImageService, ProductImageService>();
builder.Services.AddTransient<IStudioReservationService, StudioReservationService>();
builder.Services.AddTransient<IOrderDetailService,OrderDetailsService>();
builder.Services.AddTransient<IProductService, ProductService>();
builder.Services.AddTransient<IMQRabbitService, MQRabbitService>();
builder.Services.AddTransient<BaseState>();
builder.Services.AddTransient<DraftState>();
builder.Services.AddTransient<ConfirmedState>();
builder.Services.AddTransient<CancelledState>();

var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
builder.Services.AddDbContext<MusicShopDBContext>(options =>
    options.UseSqlServer(connectionString));


builder.Services.AddAuthentication("BasicAuthentication").AddScheme<AuthenticationSchemeOptions, BasicAuthenticationHandler>("BasicAuthentication", null);

var app = builder.Build();


if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}


app.UseAuthentication();

app.UseAuthorization();

app.MapControllers();

using (var scope = app.Services.CreateScope())
{
    var dataContext = scope.ServiceProvider.GetRequiredService<MusicShopDBContext>();
    //dataContext.Database.EnsureCreated();

    dataContext.Database.Migrate();
}

app.Run();
