FROM gitpod/workspace-postgres

USER root

ENV DEBIAN_FRONTEND noninteractive

# Install Erlang, Elixir, Hex and Rebar
RUN curl -fsSL https://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc | sudo gpg --dearmor -o /usr/share/keyrings/erlang_solutions.gpg.key \
    && echo "deb [signed-by=/usr/share/keyrings/erlang_solutions.gpg.key] https://packages.erlang-solutions.com/ubuntu focal contrib" | sudo tee /etc/apt/sources.list.d/erlang.list > /dev/null \
    && apt update \
    && install-packages \
        elixir
RUN sudo apt-get update
RUN sudo apt-get install erlang-parsetools
RUN sudo apt-get install erlang-dev
RUN sudo apt-get install erlang-xmerl

# RUN sudo apt-get install esl-erlang -y
# RUN sudo apt-get install elixir -y
RUN sudo apt-get install inotify-tools -y
RUN sudo mix local.hex --force
RUN sudo mix local.rebar --force

USER gitpod