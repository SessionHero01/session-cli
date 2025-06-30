use reqwest::{ClientBuilder, NoProxy, Proxy};

pub fn read_system_proxy() -> Vec<Proxy> {
    let mut proxies = vec![];

    // Parse http proxy
    match std::env::var("HTTP_PROXY") {
        Ok(http_proxy) if !http_proxy.trim().is_empty() => match Proxy::http(&http_proxy) {
            Ok(v) => proxies.push(v.no_proxy(NoProxy::from_env())),
            Err(e) => {
                tracing::error!("Error parsing HTTP_PROXY: {e:?}");
            }
        },
        _ => {}
    }

    // Parse https proxy
    match std::env::var("HTTPS_PROXY") {
        Ok(https_proxy) if !https_proxy.trim().is_empty() => match Proxy::https(&https_proxy) {
            Ok(v) => proxies.push(v.no_proxy(NoProxy::from_env())),
            Err(e) => {
                tracing::error!("Error parsing HTTPS_PROXY: {e:?}");
            }
        },
        _ => {}
    }

    // Parse all proxy
    match std::env::var("ALL_PROXY") {
        Ok(all_proxy) if !all_proxy.trim().is_empty() => match Proxy::all(&all_proxy) {
            Ok(v) => proxies.push(v.no_proxy(NoProxy::from_env())),
            Err(e) => {
                tracing::error!("Error parsing ALL_PROXY: {e:?}");
            }
        },
        _ => {}
    }

    proxies
}

pub trait ClientBuilderProxyExt {
    fn apply_system_proxy(self) -> Self;
}

impl ClientBuilderProxyExt for ClientBuilder {
    fn apply_system_proxy(self) -> Self {
        let proxies = read_system_proxy();
        let mut client_builder = self;
        for proxy in proxies {
            client_builder = client_builder.proxy(proxy);
        }
        client_builder
    }
}
