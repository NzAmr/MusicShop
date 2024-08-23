using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MusicShop.Services.Migrations
{
    public partial class OrderShippingFix : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Customer_ShippingInfo",
                table: "Customer");

            migrationBuilder.DropForeignKey(
                name: "FK_ShippingInfo_Customer_CustomerId1",
                table: "ShippingInfo");

            migrationBuilder.DropIndex(
                name: "IX_ShippingInfo_CustomerId1",
                table: "ShippingInfo");

            migrationBuilder.DropIndex(
                name: "IX_Customer_ShippingInfoID",
                table: "Customer");

            migrationBuilder.DropColumn(
                name: "CustomerId1",
                table: "ShippingInfo");

            migrationBuilder.CreateIndex(
                name: "IX_ShippingInfo_CustomerId",
                table: "ShippingInfo",
                column: "CustomerId",
                unique: true,
                filter: "[CustomerId] IS NOT NULL");

            migrationBuilder.AddForeignKey(
                name: "FK_ShippingInfo_Customer",
                table: "ShippingInfo",
                column: "CustomerId",
                principalTable: "Customer",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_ShippingInfo_Customer",
                table: "ShippingInfo");

            migrationBuilder.DropIndex(
                name: "IX_ShippingInfo_CustomerId",
                table: "ShippingInfo");

            migrationBuilder.AddColumn<int>(
                name: "CustomerId1",
                table: "ShippingInfo",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.CreateIndex(
                name: "IX_ShippingInfo_CustomerId1",
                table: "ShippingInfo",
                column: "CustomerId1");

            migrationBuilder.CreateIndex(
                name: "IX_Customer_ShippingInfoID",
                table: "Customer",
                column: "ShippingInfoID");

            migrationBuilder.AddForeignKey(
                name: "FK_Customer_ShippingInfo",
                table: "Customer",
                column: "ShippingInfoID",
                principalTable: "ShippingInfo",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_ShippingInfo_Customer_CustomerId1",
                table: "ShippingInfo",
                column: "CustomerId1",
                principalTable: "Customer",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
