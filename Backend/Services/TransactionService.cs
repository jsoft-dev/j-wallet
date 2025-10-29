using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using Backend.Data;
using Backend.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;

namespace Backend.Services;

public interface ITransactionService
{
    Task<TransactionResponse> GetAll();
}

public class TransactionResponse
{
    public bool Success { get; set; }
    public List<Transaction>? Data { get; set; }
    public Exception? Exception { get; set; }
}

public class TransactionService : ITransactionService
{
    private readonly IConfiguration _configuration;
    private readonly ApplicationDbContext _dbContext;

    public TransactionService(IConfiguration configuration, ApplicationDbContext dbContext)
    {
        _configuration = configuration;
        _dbContext = dbContext;
    }

    public async Task<TransactionResponse> GetAll()
    {
        try
        {
            var result = await _dbContext.Transactions.ToListAsync();

            return new TransactionResponse
            {
                Success = true,
                Data = result
            };
        }
        catch (Exception e)
        {
            return new TransactionResponse
            {
                Success = false,
                Exception = e
            };
        }
    }
}

