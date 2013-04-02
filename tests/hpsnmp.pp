include snmp
include hp_mcp
#include hp_mcp::hpsnmp
class { 'hp_mcp::hpsnmp': cmalocalhostrwcommstr => 'SomeSecureString', }
include hp_mcp::hphealth
