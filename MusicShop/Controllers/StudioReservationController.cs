using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MusicShop.Model;
using MusicShop.Model.Requests;
using MusicShop.Model.SearchObjects;
using MusicShop.Services.Interfaces;
using System;
using System.Security.Claims;

namespace MusicShop.Controllers
{
    [Authorize]
    [ApiController]
    [Route("[controller]")]
    public class StudioReservationController : BaseCRUDController<StudioReservation, StudioReservationSearchObject, StudioReservationUpsertRequest, StudioReservationUpsertRequest>
    {
        private readonly IStudioReservationService _studioReservationService;

        public StudioReservationController(IStudioReservationService studioReservationService)
            : base(studioReservationService)
        {
            _studioReservationService = studioReservationService;
        }

        [HttpPost("customer-reservation")]
        public ActionResult<StudioReservation> CustomerStudioReservation([FromBody] StudioReservationUpsertRequest request)
        {
           
            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);

            if (userIdClaim == null || !int.TryParse(userIdClaim.Value, out int customerId))
            {
                return Unauthorized("User is not authenticated or customer ID is missing.");
            }

            if (request == null || request.TimeFrom == null || request.TimeTo == null)
            {
                return BadRequest("Invalid request. TimeFrom and TimeTo are required.");
            }

            try
            {
                var reservationRequest = new StudioReservationUpsertRequest
                {
                    TimeFrom = request.TimeFrom,
                    TimeTo = request.TimeTo,
                    CustomerId = customerId 
                };

                var reservation = _studioReservationService.Insert(reservationRequest);

                return Ok(reservation);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
        [HttpGet("get-customer-reservations")]
        public ActionResult<List<StudioReservation>> CustomerStudioReservation()
        {

            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);

            if (userIdClaim == null || !int.TryParse(userIdClaim.Value, out int customerId))
            {
                return Unauthorized("User is not authenticated or customer ID is missing.");
            }
          

            try
            {
                

                var reservations = _studioReservationService.GetByCustomerId(customerId);

                return Ok(reservations);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
        [HttpPut("mark-as-confirmed")]
        public ActionResult<Model.StudioReservation> MarkAsConfirmed(int id)
        {
            try
            {
                return Ok(((IStudioReservationService)Service).MarkAsConfirmed(id));
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message);
            }
        }

        [HttpPut("mark-as-cancelled")]
        public ActionResult<Model.StudioReservation> MarkAsCancelled(int id)
        {
            try
            {
                return Ok(((IStudioReservationService)Service).MarkAsCancelled(id));
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message);
            }
        }
    }

}
