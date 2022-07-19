if not(libisloaded('Ginkgo_Driver'))
    [notfound,warnings] = loadlibrary('Ginkgo_Driver', 'ControlSPI.h', 'addheader', 'ErrorType.h', 'alias', 'lib');
end
%[notfound,warnings] = loadlibrary('Ginkgo_Driver');
libfunctions('lib')

scan_device(1);
open_device;
init_spi;
