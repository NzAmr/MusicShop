using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MusicShop.Services.Migrations
{
    public partial class Init : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Brand",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Brand", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Employee",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    FirstName = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    LastName = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    Username = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    Email = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: true),
                    PasswordHash = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    PasswordSalt = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    Status = table.Column<bool>(type: "bit", nullable: true),
                    PhoneNumber = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: true),
                    DateOfBirth = table.Column<DateTime>(type: "date", nullable: true),
                    DateOfEmployment = table.Column<DateTime>(type: "date", nullable: true),
                    CreatedAt = table.Column<DateTime>(type: "datetime", nullable: true),
                    UpdatedAt = table.Column<DateTime>(type: "datetime", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Employee", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "GearCategory",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_GearCategory", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "GuitarType",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_GuitarType", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "ProductImage",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Data = table.Column<byte[]>(type: "varbinary(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ProductImage", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "ShippingInfo",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Country = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    StateOrProvince = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    City = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    ZipCode = table.Column<string>(type: "nvarchar(12)", maxLength: 12, nullable: true),
                    StreetAddress = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ShippingInfo", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Products",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ProductNumber = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    ProductImageId = table.Column<int>(type: "int", nullable: true),
                    BrandId = table.Column<int>(type: "int", nullable: true),
                    Model = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Price = table.Column<decimal>(type: "decimal(18,2)", nullable: true),
                    Description = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: true),
                    UpdatedAt = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Products", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Products_Brand_BrandId",
                        column: x => x.BrandId,
                        principalTable: "Brand",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_Products_ProductImage_ProductImageId",
                        column: x => x.ProductImageId,
                        principalTable: "ProductImage",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "Customer",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    FirstName = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    LastName = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    Username = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    Email = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: true),
                    ShippingInfoID = table.Column<int>(type: "int", nullable: true),
                    PasswordHash = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    PasswordSalt = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    Status = table.Column<bool>(type: "bit", nullable: true),
                    PhoneNumber = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: true),
                    CreatedAt = table.Column<DateTime>(type: "datetime", nullable: true),
                    UpdatedAt = table.Column<DateTime>(type: "datetime", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Customer", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Customer_ShippingInfo",
                        column: x => x.ShippingInfoID,
                        principalTable: "ShippingInfo",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "Amplifier",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false),
                    Voltage = table.Column<int>(type: "int", nullable: true),
                    PowerRating = table.Column<int>(type: "int", nullable: true),
                    HeadphoneJack = table.Column<bool>(type: "bit", nullable: true),
                    Usbjack = table.Column<bool>(type: "bit", nullable: true),
                    NumberOfPresets = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Amplifier", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Amplifier_Products_Id",
                        column: x => x.Id,
                        principalTable: "Products",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "Bass",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false),
                    GuitarTypeId = table.Column<int>(type: "int", nullable: true),
                    Pickups = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Frets = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Bass", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Bass_GuitarType_GuitarTypeId",
                        column: x => x.GuitarTypeId,
                        principalTable: "GuitarType",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_Bass_Products_Id",
                        column: x => x.Id,
                        principalTable: "Products",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "Gear",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false),
                    GearCategoryId = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Gear", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Gear_GearCategory_GearCategoryId",
                        column: x => x.GearCategoryId,
                        principalTable: "GearCategory",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_Gear_Products_Id",
                        column: x => x.Id,
                        principalTable: "Products",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "Guitar",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false),
                    GuitarTypeId = table.Column<int>(type: "int", nullable: true),
                    Pickups = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    PickupConfiguration = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Frets = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Guitar", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Guitar_GuitarType_GuitarTypeId",
                        column: x => x.GuitarTypeId,
                        principalTable: "GuitarType",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_Guitar_Products_Id",
                        column: x => x.Id,
                        principalTable: "Products",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "OrderDetails",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ProductId = table.Column<int>(type: "int", nullable: true),
                    OrderNumber = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    OrderDate = table.Column<DateTime>(type: "date", nullable: true),
                    ShippingPrice = table.Column<decimal>(type: "decimal(18,2)", nullable: true),
                    ShippingStatus = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_OrderDetails", x => x.Id);
                    table.ForeignKey(
                        name: "FK_OrderDetails_Product",
                        column: x => x.ProductId,
                        principalTable: "Products",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "Synthesizer",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false),
                    KeyboardSize = table.Column<int>(type: "int", nullable: true),
                    WeighedKeys = table.Column<bool>(type: "bit", nullable: true),
                    Polyphony = table.Column<int>(type: "int", nullable: true),
                    NumberOfPresets = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Synthesizer", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Synthesizer_Products_Id",
                        column: x => x.Id,
                        principalTable: "Products",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "StudioReservation",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    CustomerId = table.Column<int>(type: "int", nullable: true),
                    TimeFrom = table.Column<DateTime>(type: "date", nullable: true),
                    TimeTo = table.Column<DateTime>(type: "date", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_StudioReservation", x => x.Id);
                    table.ForeignKey(
                        name: "FK_StudioReservation_Customer",
                        column: x => x.CustomerId,
                        principalTable: "Customer",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateIndex(
                name: "IX_Bass_GuitarTypeId",
                table: "Bass",
                column: "GuitarTypeId");

            migrationBuilder.CreateIndex(
                name: "IX_Customer_ShippingInfoID",
                table: "Customer",
                column: "ShippingInfoID");

            migrationBuilder.CreateIndex(
                name: "IX_Gear_GearCategoryId",
                table: "Gear",
                column: "GearCategoryId");

            migrationBuilder.CreateIndex(
                name: "IX_Guitar_GuitarTypeId",
                table: "Guitar",
                column: "GuitarTypeId");

            migrationBuilder.CreateIndex(
                name: "IX_OrderDetails_ProductId",
                table: "OrderDetails",
                column: "ProductId");

            migrationBuilder.CreateIndex(
                name: "IX_Products_BrandId",
                table: "Products",
                column: "BrandId");

            migrationBuilder.CreateIndex(
                name: "IX_Products_ProductImageId",
                table: "Products",
                column: "ProductImageId");

            migrationBuilder.CreateIndex(
                name: "IX_StudioReservation_CustomerId",
                table: "StudioReservation",
                column: "CustomerId");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Amplifier");

            migrationBuilder.DropTable(
                name: "Bass");

            migrationBuilder.DropTable(
                name: "Employee");

            migrationBuilder.DropTable(
                name: "Gear");

            migrationBuilder.DropTable(
                name: "Guitar");

            migrationBuilder.DropTable(
                name: "OrderDetails");

            migrationBuilder.DropTable(
                name: "StudioReservation");

            migrationBuilder.DropTable(
                name: "Synthesizer");

            migrationBuilder.DropTable(
                name: "GearCategory");

            migrationBuilder.DropTable(
                name: "GuitarType");

            migrationBuilder.DropTable(
                name: "Customer");

            migrationBuilder.DropTable(
                name: "Products");

            migrationBuilder.DropTable(
                name: "ShippingInfo");

            migrationBuilder.DropTable(
                name: "Brand");

            migrationBuilder.DropTable(
                name: "ProductImage");
        }
    }
}
