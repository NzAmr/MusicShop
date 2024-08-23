using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MusicShop.Services.Migrations
{
    public partial class CustomerShippingFix : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_ShippingInfo_CustomerId",
                table: "ShippingInfo");

            migrationBuilder.DropColumn(
                name: "ShippingInfoID",
                table: "Customer");

            migrationBuilder.AlterColumn<int>(
                name: "CustomerId",
                table: "ShippingInfo",
                type: "int",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(int),
                oldType: "int",
                oldNullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_ShippingInfo_CustomerId",
                table: "ShippingInfo",
                column: "CustomerId");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_ShippingInfo_CustomerId",
                table: "ShippingInfo");

            migrationBuilder.AlterColumn<int>(
                name: "CustomerId",
                table: "ShippingInfo",
                type: "int",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.AddColumn<int>(
                name: "ShippingInfoID",
                table: "Customer",
                type: "int",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_ShippingInfo_CustomerId",
                table: "ShippingInfo",
                column: "CustomerId",
                unique: true,
                filter: "[CustomerId] IS NOT NULL");
        }
    }
}
