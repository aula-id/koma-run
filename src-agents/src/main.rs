use clap::{Parser, Subcommand};
use symposium_agents::run_agent_core;

#[derive(Parser)]
#[command(name = "agent", about = "Symposium agent CLI")]
struct Cli {
    #[command(subcommand)]
    command: Commands,
}

#[derive(Subcommand)]
enum Commands {
    /// Standalone one-shot CLI mode
    Run,
    /// Run as a local daemon listening for commands
    Serve,
    /// Connect to backend over WebSocket
    Connect {
        #[arg(long)]
        url: String,
    },
}

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    tracing_subscriber::fmt::init();

    let cli = Cli::parse();

    match cli.command {
        Commands::Run => {
            tracing::info!("agent run: one-shot CLI mode");
            run_agent_core().await?;
        }
        Commands::Serve => {
            tracing::info!("agent serve: starting local daemon");
            run_agent_core().await?;
        }
        Commands::Connect { url } => {
            tracing::info!("agent connect: connecting to backend at {}", url);
            run_agent_core().await?;
        }
    }

    Ok(())
}
