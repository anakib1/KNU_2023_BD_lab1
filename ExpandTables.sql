create table UserStatistics
(
    statisticsId   binary(16)    not null
        primary key,
    userId         binary(16)    not null,
    content        varchar(2048) null,
    statisticsTime timestamp     not null,
    constraint UserStatistics_Users_userId_fk
        foreign key (userId) references Users (userId)
);

create index UserStatisticsByUserIdAndTime
    on UserStatistics (userId, statisticsTime);


create table UserActions
(
    actionId      binary(16)    not null
        primary key,
    userId        binary(16)    not null,
    actionType    int           not null,
    actionContent varchar(2048) null,
    actionTime    timestamp     not null,
    constraint UserActions_Users_userId_fk
        foreign key (userId) references Users (userId)
);

create index UserActionsByUserIdAndTime
    on UserActions (userId, actionTime);

