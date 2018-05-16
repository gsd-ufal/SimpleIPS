# Developer Documentation
## Architecture overview
Code is modular for enabling further microservice implementation.

TODO

# TODO
## Use `module` 
Each Julia `module` will represent a microservice. Services should be externally called through the exported functions. These functions represent the microservices functions exposed for public use. Service internal functions are not `export`ed.

## Create Julia package

## Code accelerating
 * Multi-thread processing 
 * ParallelAccelerator.jl
 * GPU support

## Multi-client support
 * Julia Tasks

## Use third-party data sets
* DescartesLabs
* Sentinel/Landsat hubs

## RESTful API
* Encapsulate as microservices

## Third-party authentication

Github, Google, Facebook, Linkedin, etc.

## Integration/Backends
* JuliaRun
* Cluster (Kubernetes, etc.)
* Amazon, Azure, Google container services