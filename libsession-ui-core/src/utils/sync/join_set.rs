use std::future::Future;
use std::pin::Pin;

pub struct LocalJoinSet<F> {
    futures: Vec<Pin<Box<F>>>,
}

impl<F> LocalJoinSet<F> {
    pub fn new() -> Self {
        LocalJoinSet {
            futures: Vec::new(),
        }
    }

    pub fn push(&mut self, future: F) {
        self.futures.push(Box::pin(future));
    }

    pub fn next(&mut self) -> Next<F> {
        Next(self)
    }
}

pub struct Next<'a, F>(&'a mut LocalJoinSet<F>);

impl<'a, F: Future> Future for Next<'a, F> {
    type Output = F::Output;

    fn poll(
        mut self: Pin<&mut Self>,
        cx: &mut std::task::Context<'_>,
    ) -> std::task::Poll<Self::Output> {
        let first_completed = self
            .0
            .futures
            .iter_mut()
            .enumerate()
            .map(|(index, r)| (index, r.as_mut().poll(cx)))
            .filter(|r| r.1.is_ready())
            .next();

        if let Some((index, result)) = first_completed {
            self.0.futures.swap_remove(index);
            result
        } else {
            std::task::Poll::Pending
        }
    }
}
