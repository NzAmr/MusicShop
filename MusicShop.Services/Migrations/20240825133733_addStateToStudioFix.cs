using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MusicShop.Services.Migrations
{
    public partial class addStateToStudioFix : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_OrderDetails_ShippingInfo_ShippingInfoId",
                table: "OrderDetails");

            migrationBuilder.DropPrimaryKey(
                name: "PK_OrderDetails",
                table: "OrderDetails");

            migrationBuilder.RenameTable(
                name: "OrderDetails",
                newName: "Order");

            migrationBuilder.RenameIndex(
                name: "IX_OrderDetails_ShippingInfoId",
                table: "Order",
                newName: "IX_Order_ShippingInfoId");

            migrationBuilder.RenameIndex(
                name: "IX_OrderDetails_ProductId",
                table: "Order",
                newName: "IX_Order_ProductId");

            migrationBuilder.AddPrimaryKey(
                name: "PK_Order",
                table: "Order",
                column: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Order_ShippingInfo_ShippingInfoId",
                table: "Order",
                column: "ShippingInfoId",
                principalTable: "ShippingInfo",
                principalColumn: "Id");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Order_ShippingInfo_ShippingInfoId",
                table: "Order");

            migrationBuilder.DropPrimaryKey(
                name: "PK_Order",
                table: "Order");

            migrationBuilder.RenameTable(
                name: "Order",
                newName: "OrderDetails");

            migrationBuilder.RenameIndex(
                name: "IX_Order_ShippingInfoId",
                table: "OrderDetails",
                newName: "IX_OrderDetails_ShippingInfoId");

            migrationBuilder.RenameIndex(
                name: "IX_Order_ProductId",
                table: "OrderDetails",
                newName: "IX_OrderDetails_ProductId");

            migrationBuilder.AddPrimaryKey(
                name: "PK_OrderDetails",
                table: "OrderDetails",
                column: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_OrderDetails_ShippingInfo_ShippingInfoId",
                table: "OrderDetails",
                column: "ShippingInfoId",
                principalTable: "ShippingInfo",
                principalColumn: "Id");
        }
    }
}
