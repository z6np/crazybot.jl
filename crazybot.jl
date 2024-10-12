# crazybot.jl

using Sockets

const SERVER = "irc.libera.chat"
const PORT = 6667
const CHANNEL = "##?"
const NICKNAME = "crazybot"

function connect_to_server()
    sock = connect(SERVER, PORT)
    println("Connected to $SERVER on port $PORT")
    return sock
end

function join_channel(sock)
    write(sock, "NICK $NICKNAME\r\n")
    write(sock, "USER $NICKNAME 0 * :$NICKNAME\r\n")
    write(sock, "JOIN $CHANNEL\r\n")
end

function main()
    sock = connect_to_server()
    join_channel(sock)
    crazy_count = 0

    while !eof(sock)
        line = readline(sock)
        println("Received: $line")
        if findfirst("PING", line) == 1:4
            write(sock, "PONG "*split(line)[2]*"\r\n")
        elseif occursin(CHANNEL, line)
            if occursin("PRIVMSG", line)
                if occursin("!crazy", line)
                    crazy_count += 1
                    write(sock, "PRIVMSG $CHANNEL :\x0309o_O \x030times !crazy [\x0306$crazy_count\x030]\r\n")
                elseif occursin(NICKNAME, line)
                    write(sock, "PRIVMSG $CHANNEL :\x030crazybot is \x039CRAZY \x030like that!\r\n")
                elseif occursin("crazy", line)
                    write(sock, "PRIVMSG $CHANNEL :\x034C\x035r\x038a\x039z\x0311y\r\n")
                end
            end
        end
    end
    close(sock)
end

main()
