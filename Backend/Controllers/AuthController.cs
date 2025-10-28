using Backend.Services;
using Microsoft.AspNetCore.Mvc;

namespace Backend.Controllers;

[ApiController]
[Route("api/[controller]")]
public class AuthController : ControllerBase
{
    private readonly IAuthService _authService;

    public AuthController(IAuthService authService)
    {
        _authService = authService;
    }

    [HttpPost("login")]
    public async Task<IActionResult> Login([FromBody] LoginRequest request)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest(new LoginResponse
            {
                Success = false,
                Message = "Invalid request"
            });
        }

        var response = await _authService.Login(request);

        if (response.Success)
        {
            return Ok(response);
        }

        return Unauthorized(response);
    }

    [HttpPost("register")]
    public async Task<IActionResult> Register([FromBody] RegisterRequest request)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest(new { success = false, message = "Invalid request" });
        }

        var success = await _authService.Register(request);

        if (success)
        {
            return Ok(new { success = true, message = "Registration successful. You can now login." });
        }

        return BadRequest(new { success = false, message = "Registration failed. Username or email may already exist." });
    }

    [HttpPost("validate")]
    public IActionResult ValidateToken([FromBody] string token)
    {
        var isValid = _authService.ValidateToken(token);
        return Ok(new { isValid });
    }
}

