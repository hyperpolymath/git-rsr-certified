//! Database abstraction layer for RSR compliance data
//!
//! Multi-database architecture:
//! - DragonflyDB: Caching, job queues (Redis-compatible)
//! - SurrealDB: Documents, compliance reports
//! - ArangoDB: Dependency graphs, relationships
//!
//! Enable with feature flags: `cache`, `documents`, `graphs`, or `all-dbs`

#[cfg(feature = "cache")]
pub mod cache;
#[cfg(feature = "documents")]
pub mod documents;
#[cfg(feature = "graphs")]
pub mod graphs;

use crate::Result;

/// Combined database pool
#[derive(Default)]
pub struct DatabasePool {
    #[cfg(feature = "cache")]
    pub cache: Option<cache::DragonflyPool>,
    #[cfg(feature = "documents")]
    pub docs: Option<documents::SurrealPool>,
    #[cfg(feature = "graphs")]
    pub graphs: Option<graphs::ArangoPool>,
}

/// Initialize all database connections based on enabled features
#[allow(unused_mut)]
pub async fn init() -> Result<DatabasePool> {
    let mut pool = DatabasePool::default();

    #[cfg(feature = "cache")]
    {
        pool.cache = Some(cache::DragonflyPool::connect_from_env().await?);
    }

    #[cfg(feature = "documents")]
    {
        pool.docs = Some(documents::SurrealPool::connect_from_env().await?);
    }

    #[cfg(feature = "graphs")]
    {
        pool.graphs = Some(graphs::ArangoPool::connect_from_env().await?);
    }

    Ok(pool)
}

impl DatabasePool {
    /// Run database migrations
    #[allow(unused_variables)]
    pub async fn migrate(&self) -> Result<()> {
        #[cfg(feature = "documents")]
        if let Some(ref docs) = self.docs {
            docs.migrate().await?;
        }

        #[cfg(feature = "graphs")]
        if let Some(ref graphs) = self.graphs {
            graphs.migrate().await?;
        }

        Ok(())
    }

    /// Health check all databases
    pub async fn health_check(&self) -> Result<DatabaseHealth> {
        Ok(DatabaseHealth {
            #[cfg(feature = "cache")]
            cache: self.cache.as_ref().map(|c| c.ping()).is_some(),
            #[cfg(not(feature = "cache"))]
            cache: false,

            #[cfg(feature = "documents")]
            documents: self.docs.as_ref().is_some(),
            #[cfg(not(feature = "documents"))]
            documents: false,

            #[cfg(feature = "graphs")]
            graphs: self.graphs.as_ref().is_some(),
            #[cfg(not(feature = "graphs"))]
            graphs: false,
        })
    }
}

/// Database health status
#[derive(Debug, Clone, serde::Serialize)]
pub struct DatabaseHealth {
    pub cache: bool,
    pub documents: bool,
    pub graphs: bool,
}
