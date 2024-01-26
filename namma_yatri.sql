select * from namma_yatri.assembly;
select * from namma_yatri.duration;
select * from namma_yatri.payment;
select * from namma_yatri.trip_details;
select * from namma_yatri.trips;

-- calculate total no. of succesful trips?
select count(tripid) as total_trips from namma_yatri.trips;
select tripid, count(tripid) as more_than_1_trip from namma_yatri.trip_details
group by tripid having count(tripid)>1 ;

-- total no. of distinct driver?
select count(distinct driverid) as total_drivers from namma_yatri.trips;

-- total earnings?
select sum(fare) as total_earnings from namma_yatri.trips;

-- total complete trips
select count(tripid) as completed_rides from namma_yatri.trip_details
where end_ride = 1;

-- total searches took place
select sum(searches) as total_searches from namma_yatri.trip_details;

-- total searches which got estimate
select sum(searches_got_estimate) as total_searches_estimate from namma_yatri.trip_details;

-- total searches for quotes
select sum(searches_for_quotes) as total_searches_for_quotes from namma_yatri.trip_details;

-- total searches with gpt quotes
select sum(searches_got_quotes) as total_searches_got_quotes from namma_yatri.trip_details;   

-- total trips cancelled by drivers
select count(driver_not_cancelled) as total_drivers_cancelled from namma_yatri.trip_details
where driver_not_cancelled = 0;

-- total otp entered
select sum(otp_entered) as total_otp_entered from namma_yatri.trip_details;

-- total end ride
select sum(end_ride) as total_end_ride from namma_yatri.trip_details;

-- average distance per trip
select avg(distance) as avg_distance from namma_yatri.trips;

-- average fair per trip
select avg(fare) as avg_fare from namma_yatri.trips;

-- which is most used payment method
select a.method from namma_yatri.payment a inner join 
(select faremethod,count(faremethod) as most_payment_mode from namma_yatri.trips
group by faremethod order by most_payment_mode desc limit 1) b on a.id = b.faremethod ;

-- the highest payment was made through which method
select a.method, b.highest_fare from namma_yatri.payment a inner join
(select faremethod, max(fare) as highest_fare from namma_yatri.trips 
group by faremethod order by highest_fare desc limit 1) b
on a.id = b.faremethod;

select a.method,b.total_sum_fare from namma_yatri.payment a inner join
(select faremethod, sum(fare) as total_sum_fare from namma_yatri.trips
group by faremethod order by total_sum_fare desc limit 1) b
on a.id = b.faremethod;

-- which two destination had most trips
select a.assembly, b.loc_to, b.cnt from namma_yatri.assembly a inner join
(select loc_to, count(loc_to) as cnt from namma_yatri.trips 
group by loc_to order by cnt desc limit 2) b
on a.id = b.loc_to;

-- which two location from had most trips
select a.assembly, b.loc_from, b.cnt from namma_yatri.assembly a inner join
(select loc_from, count(loc_from) as cnt from namma_yatri.trips 
group by loc_from order by cnt desc limit 2) b
on a.id = b.loc_from;

-- two most travelled route 
select a.assembly, b.loc_from, b.loc_to, b.cnt from namma_yatri.assembly a inner join
(select loc_from, loc_to, count(loc_to) cnt from namma_yatri.trips 
group by loc_from, loc_to order by cnt desc limit 2) b
on a.id = b.loc_from; 

-- top 5 earning driver
select * from
(select *,dense_rank() over (order by b.total_income desc) rnk from
(select driverid, sum(fare) as total_income from namma_yatri.trips 
group by driverid) b) a where rnk<=5;

-- which duration had more trips
select *, rank() over (order by a.cnt desc) rnk from
(select duration, count(distinct tripid) as cnt from namma_yatri.trips
group by duration )a;

-- which driver, cutomer pair had more trips 
select *, dense_rank() over(order by a.cnt desc) as rnk from
(select driverid,custid, count(tripid) as cnt from namma_yatri.trips
group by driverid, custid)a;

-- search to estimate rate
select sum(searches_got_quotes) as total_quotes_received, sum(searches_got_estimate) as total_searches,
 (sum(searches_got_quotes)/sum(searches_got_estimate))*100 as rate from namma_yatri.trip_details;
 
 -- which area got highest trips in which duration
 select * from
 (select *, rank() over(partition by duration order by a.cnt desc) as rnk from
 (select  duration, loc_from, count(tripid) as cnt from namma_yatri.trips
 group by loc_from,duration) a) c where rnk=1;
 
  -- which area got the highest fares, cancellation trips
  select *, rank() over(order by a.total_fare desc) as rnk from
  (select loc_from, sum(fare) as total_fare from namma_yatri.trips
  group by loc_from) a;
  
  select *, rank() over(order by a.total_cancellation desc) as rnk from
  (select loc_from, count(customer_not_cancelled) as total_cancellation from namma_yatri.trip_details
  where customer_not_cancelled = 0 group by loc_from) a ;
  
  
  
  
