# Developer Documentation
## Architecture overview
Code is modular for enabling further microservice implementation. Each Julia `Module` represents a microservice. Services should be externally called through the exported functions. These functions represent the microservices functions exposed for public use. Service internal functions are not `export`ed.

TODO

# TODO
* Code accelerating
 * Multi-thread processing 
 * ParallelAccelerator.jl
 * GPU support
* Multi-client support
 * Julia Tasks
* Use third-party data sets
 * DescartesLabs
 * Sentinel/Landsat hubs
 * ...
* RESTful API
* Encapsulate as microservices