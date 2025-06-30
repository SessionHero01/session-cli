#![recursion_limit = "256"]

use clap::{Parser, Subcommand};
use session_ui_core::{create_account_service, create_global_service};
use std::net::SocketAddr;
use std::path::PathBuf;
use tracing_subscriber::EnvFilter;

#[derive(Parser, Debug)]
struct Cli {
    #[command(subcommand)]
    commands: Commands,
}

#[derive(Subcommand, Debug)]
enum Commands {
    GenKey,
    PrintConfigs {
        #[clap(short, long, env)]
        mnemonic: String,
    },

    RunAccountServer {
        #[clap(short, long, env)]
        mnemonic: String,

        /// Port to run debug server on. By default, the server will bind to a random port locally.
        #[clap(short, long, env, default_value = "127.0.0.1:0")]
        listen: SocketAddr,

        /// Path to the data folder
        #[clap(short, long, env)]
        data_path: PathBuf,

        /// Reset the account state on start.
        #[clap(long, env, default_value = "false")]
        reset_on_start: bool,

        /// Password to encrypt the database with.
        #[clap(long, env)]
        db_password: Option<String>,
    },

    RunGlobalServer {
        /// Port to run debug server on. By default, the server will bind to a random port locally.
        #[clap(short, long, env, default_value = "127.0.0.1:0")]
        listen: SocketAddr,

        /// Path to the data directory. By default, the data directory is set to the system's data directory.
        #[clap(short, long, env, default_value_t = get_default_data_dir())]
        data_dir: String,
    },
}

fn get_default_data_dir() -> String {
    dirs::data_dir()
        .expect("To have a data dir")
        .join(env!("CARGO_PKG_NAME"))
        .to_str()
        .unwrap()
        .to_string()
}

fn main() {
    let _ = dotenvy::dotenv();

    let subscriber = tracing_subscriber::fmt()
        // Use a more compact, abbreviated log format
        .compact()
        // Display source code file paths
        .with_file(false)
        // Display source code line numbers
        .with_line_number(false)
        // Display the thread ID an event was recorded on
        .with_thread_ids(false)
        // Don't display the event's target (module path)
        .with_target(false)
        .with_env_filter(EnvFilter::from_default_env())
        // Build the subscriber
        .finish();

    tracing::subscriber::set_global_default(subscriber).unwrap();

    let rt = tokio::runtime::Builder::new_multi_thread()
        .worker_threads(2)
        .enable_all()
        .build()
        .expect("To build tokio runtime");

    let Cli { commands } = Cli::parse();
    rt.block_on(async move {
        match commands {
            Commands::GenKey => {}
            Commands::PrintConfigs { mnemonic: _ } => {
                todo!()
            }

            Commands::RunAccountServer {
                mnemonic,
                listen,
                data_path,
                reset_on_start,
                db_password,
            } => {
                if reset_on_start {
                    let _ = std::fs::remove_dir_all(&data_path);
                }

                let (join_set, listen) =
                    create_account_service(&data_path, &mnemonic, db_password, listen)
                        .await
                        .expect("To create account service");

                tracing::info!("Account service listening on {listen}");
                if let Some(e) = join_set
                    .join_all()
                    .await
                    .into_iter()
                    .filter_map(|r| r.err())
                    .next()
                {
                    panic!("Error running account service: {e}");
                }
            }

            Commands::RunGlobalServer { listen, data_dir } => {
                let data_dir: PathBuf = data_dir.parse().expect("A valid data directory");
                let (mut js, addr) = create_global_service(Default::default(), listen, data_dir)
                    .expect("To create global service");

                tracing::info!("Manager service listening on {addr}");
                if let Some(Ok(Err(e))) = js.join_next().await {
                    panic!("Error running global service: {e}");
                }
            }
        }
    });
}
