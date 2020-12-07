from ctypes import *
class ETH(Structure):
    _pack_=1
    _fields_ = [
    ("ethDstU", c_uint32),
    ("ethDstL", c_uint16),
    ("ethSrcU", c_uint32),
    ("ethSrcL", c_uint16),
    ("type", c_ushort,8)
    ]
	
PROTO = { 
         "icmp":1,
         "igmp":2,
         "ipv4":4,
         "tcp":6,
         "igp":9,
         "udp":17,
         "ipv6":41,
         "ipv6-route":43,
         "ipv6-frag":44,
         "gre":47,
         "dsr":48,
         "esp":50,
         "ipv6-icmp":58,
         "ipv6-nonxt":59,
         "ipv6-opts":60,
         "eigrp":88,
         "ospf":89,
         "mtp":92,
         "l2tp":116,
         "sctp":132 
}

class IP(Structure):
    _pack_=1
    _fields_ = [
    ("version", c_ubyte,4),
    ("ihl", c_ubyte,4),
    ("tos", c_ubyte),
    ("length", c_ushort),
    ("id", c_ushort),
    ("flags", c_ubyte,3),
    ("fragOffset", c_ushort,13),
    ("ttl", c_ubyte),
    ("proto", c_ubyte),
    ("checksum", c_ushort),
    ("ipSrc", c_uint),
    ("ipDst", c_uint),
    ]

class TCP(Structure):
    _fields_ = [
    ("test", c_ubyte )
    ]
    
class UDP(Structure):
    _fields_ = [
    ("test", c_ubyte )
    ]
