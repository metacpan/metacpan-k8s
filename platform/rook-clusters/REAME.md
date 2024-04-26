# root-storage

IGNORE FOR NOW - might be wrong!!!

Create two available types of storage for applications in the cluster

- data-volatile: anything that is ephemeral / can be re-created
- data-durable: data which can not be reproduced

### Durable examples
```mermaid
graph LR
    
    DP[data-permanent]
    CM[CPAN Mirror]
    CPAN[cpan.metacpan.org]
    API[api.metacpan.org]
    RRR[rrr-watcher]

    DC[Devel Cover]
    DCP[Devel Cover processors]

    DP --> CM
    DP --> DC
    DC -- "Read/Write" --> DCP
    CM -- "Read Only" --> CPAN
    CM -- "Read Only" --> API
    CM -- "Read/Write" --> RRR
```

### Volatile examples

```mermaid
graph LR
    
    DP[data-tmp]
    
    MCTMP[Sources unzipped]
    GITMIRROR[Unzipped latest for grep]
    APPAPI[api.metacpan.org]
    APPGREP[grep.metacpan.org]

    DP --> MCTMP
    DP --> GITMIRROR

    MCTMP -- "Read/write" --> APPAPI
    GITMIRROR -- "Read/write" --> APPGREP
```