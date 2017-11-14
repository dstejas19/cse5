set ns [new Simulator]
set tf [open lab2.tr w]
$ns trace-all $tf
set nf [open lab2.nam w]
$ns namtrace-all $nf

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
$ns color 1 "blue"
$n1 label "Source"
$n2 label "Error node"
$n5 label "Destination"

#The below code is used to create two Lans (Lan1 and Lan2).

$ns make-lan "$n0 $n1 $n2" 10Mb 10ms LL Queue/DropTail Mac/802_3 
$ns make-lan "$n3 $n4 $n5" 10Mb 10ms LL Queue/DropTail Mac/802_3

# connect node n2 and n4

$ns duplex-link $n2 $n4 100Mb 10ms DropTail 
$ns duplex-link-op $n2 $n4 color "green"
set udp1 [new Agent/UDP]
$ns attach-agent $n1 $udp1
set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1
set null5 [new Agent/Null]
$ns attach-agent $n5 $null5
$ns connect $udp1 $null5

#data rate- change this to change the data rate 
$cbr1 set packetSize_ 1000 
$cbr1 set interval_ 0.001

$udp1 set class_ 1
 
set err [new ErrorModel]
$ns lossmodel $err $n2 $n4 
$err set rate_ 0.1
proc finish {} { 
global ns tf nf
$ns flush-trace
exec nam lab2.nam &
close $tf
close $nf 
exit 0
}
$ns at 6.0 "finish"
$ns at 0.1 "$cbr1 start" 
$ns run
