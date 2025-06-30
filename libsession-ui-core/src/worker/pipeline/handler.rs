pub trait MessageHandler<M> {
    fn handle(&mut self, messages: &mut Vec<M>, next_handler: &mut dyn MessageHandler<M>);
}

struct MessageHandlerChain();
