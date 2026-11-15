use axum::{Router, routing::get};

#[tokio::main]
async fn main() {
    let app = Router::new().route("/info", get(info));
    let listener = tokio::net::TcpListener::bind("0.0.0.0:3000").await.unwrap();
    println!("Server listening on 0.0.0.0:3000");
    axum::serve(listener, app).await.unwrap()
}

async fn info() -> String {
    println!("Request received !");
    "Server running on EC2".to_string()
}
