# Jolie testing suite (jot)

jot will initially contains 2 different features for the jolie testing suite

1. launch testing see `service.test.ol`
2. mockup generator, the mockup generator goal is to generate the mockup service on given jolie interface. It should be use to mock an implementation of a service via an interface

for example on 2

```jolie
// service2.ol

interface A {
    RequestResponse: twice(int)(int)
}

service Main {
    // ... implementation
}
```

after running

```jolie
jot generate --name mainMock service2.A 
```

generates following

```jolie
// service2_mock.ol

interface A {
    RequestResponse: twice(int)(int)
}

type comm {
    location: string
    protocol: string
}

service mainMock(param: comm) {

    inputPort IP {
        location: p.location
        protocol: p.protocol
        interfaces: A
    }

    twice(req)(res){
        // mock implementation
    }
}
```

then we can attach service2_mock to any service that we need. for both testing and prototyping.

Note:

things to think of, inspect the internal behavior of the service eg. if the operation is called. perhaps fairly easy via creating a proxy service which act as an orchestrator between services. And this proxy service observes the calling of every operation and checks it's order/correctness.
