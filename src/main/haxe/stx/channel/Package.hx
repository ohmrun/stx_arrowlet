package stx.channel;

typedef Channel<I,O,E>                  = stx.channel.pack.Channel<I,O,E>;
typedef Attempt<I,O,E>                  = stx.channel.pack.Attempt<I,O,E>;
typedef Resolve<I,O,E>                  = stx.channel.pack.Resolve<I,O,E>;
typedef Recover<I,E>                    = stx.channel.pack.Recover<I,E>;
typedef Execute<E>                      = stx.channel.pack.Execute<E>;
typedef Command<I,E>                    = stx.channel.pack.Command<I,E>;
typedef Proceed<O,E>                    = stx.channel.pack.Proceed<O,E>;
typedef Reframe<S,A,E>                  = stx.channel.pack.Reframe<S,A,E>;
typedef Arrange<S,A,R,E>                = stx.channel.pack.Arrange<S,A,R,E>;
typedef Channels                        = stx.channel.head.Channels;
typedef Proceeds                        = stx.channel.head.Proceeds;
typedef Attempts                        = stx.channel.head.Attempts;
typedef Commands                        = stx.channel.head.Commands;