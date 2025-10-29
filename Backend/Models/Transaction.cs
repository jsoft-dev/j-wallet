namespace Backend.Models;

public class Transaction
{
    public int Id { get; set; }
    public string Amount { get; set; } = string.Empty;
    public string RoutinePeriodType { get; set; } = string.Empty;
    public string DoneAt { get; set; } = string.Empty;
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
}

