
libname libraryy "F:\school\BSTA445"; *golbal stat; 
filename probly temp;
proc http
 url="https://raw.githubusercontent.com/datasets/covid-19/master/data/time-series-19-covid-combined.csv"
 method="GET"
 out=probly;
 
run;

/* Tell SAS to allow "nonstandard" names */
options validvarname=any;

/* import to a SAS data set */

proc import
  file=probly
  out=probly replace
  dbms=csv;
run;


Data libraryy.dataset;
Set probly
(where=
	(
		'Country/Region'n = 'Canada' 

	)
);
Run;
Data libraryy.dataset;
Set libraryy.dataset;
 Zero = 0;
  logConfirmed = log(Confirmed);
 run;


 Data QuebecConfirmed;
Set libraryy.dataset(where=
	(
		'Country/Region'n = 'Canada' 
		and
	('Province/State'n ='Q'
		)
	)
	);
 Zero = 0;
 logConfirmed = log(Confirmed);
 
 run;


proc sgplot data=QuebecConfirmed;
  refline 1 1.5 2 / lineattrs=graphgridlines;
  highlow x=Date high=Confirmed low=Zero / type=bar  
  group='Province/State'n 
  groupdisplay=cluster lineattrs=(color=black);
  xaxis discreteorder=data display=(nolabel);
  yaxis label='Value (/ULN)' offsetmin=0;;
  run;

















title 'Corona Cases in Quebec';
footnote j=l 'Bar Chart on Discrete Axis';

ods graphics on /  /*Chart characteristics*/
      width=30 in
	  height=30 in
      outputfmt=gif
      imagemap=on
      imagename="MyBoxplot"
      border=off;

proc sgplot data=libraryy.dataset;
  refline 1 1.5 2 / lineattrs=graphgridlines;
  highlow x=Date high=Confirmed low=Zero / type=bar  
  group='Province/State'n 
  groupdisplay=cluster lineattrs=(color=black);
  xaxis discreteorder=data display=(nolabel);
  yaxis label='Value (/ULN)' offsetmin=0;;
  run;

proc print data=libraryy.dataset label ;

var Date 'Province/State'n Confirmed;
run;


/*All cases in Canada confirmed cases*/

title 'Corona Cases in Canadas provinces';
footnote j=l 'Bar Chart on Discrete Axis';

ods graphics on /  /*Chart characteristics*/
      width=10 in
	  height=10 in
      outputfmt=gif
      imagemap=on
     imagename="MyBoxplot"
 ;
 * border=off;


PROC SGPLOT data=libraryy.dataset;
 SERIES X = Date Y = Confirmed / LEGENDLABEL = 'Quebec' 
 group='Province/State'n 
 LINEATTRS = (THICKNESS = 2);
XAXIS TYPE = TIME;

run;




title 'Corona Cases in Canadas provinces in log';
footnote j=l 'Bar Chart on Dicrete Axis';

ods graphics on /  /*Chart characteristics*/
      width=10 in
	  height=10 in
      outputfmt=gif
      imagemap=on
     imagename="MyBoxplot"
 ;
 * border=off;


PROC SGPLOT data=libraryy.dataset;
 SERIES X = Date Y = logConfirmed / LEGENDLABEL = 'Quebec' 
 group='Province/State'n 
  LINEATTRS = (THICKNESS = 2);
XAXIS TYPE = TIME;

run;






/*First cases of corona around the world first observed*/

proc sort data=probly out=sorted;
/*  by country;*/
/* by province;*/
/*   by descending date_confirmation ;*/
where 
 Confirmed=1;
by  Date;
/*/*by 'Country/Region'n;*/*/
by 'Province/State'n;

run;



proc sql;
create table want as
select a.*
from sorted a, (select 'Country/Region'n,'Province/State'n,Confirmed as _regimen  from sorted group by 'Province/State'n having date=max(date)) b 
where a.'Province/State'n = b.'Province/State'n
group by a.'Country/Region'n ,a.'Province/State'n
/*,Confirmed,_regimen */
having date=min(date) 
and _regimen=Confirmed;
;

quit;


PROC SGPLOT Data = want;
    scatter x = Date   y = 'Country/Region'n;
	refline 'Country/Region'n /axis= y;
	refline Date /axis= x;
/*	group= 'Country/Region'n, 'Province/State'n */
/*	groupdisplay=cluster lineattrs=(color=black);*/
    title "First Case in various Countrues";
run;



/*First case in quebec only*/


proc sort data=probly out=sorted;
/*  by country;*/
/* by province;*/
/*   by descending date_confirmation ;*/
where 
'Country/Region'n ='Canada' and 
 Confirmed=1;
by  Date;
/*/*by 'Country/Region'n;*/*/
by 'Province/State'n;


proc sql;
create table wantQc as
select a.*
from sorted a, (select 'Country/Region'n,'Province/State'n,Confirmed as _regimen  from sorted group by 'Province/State'n having date=max(date)) b 
where a.'Province/State'n = b.'Province/State'n
group by a.'Country/Region'n ,a.'Province/State'n
/*,Confirmed,_regimen */
having date=min(date) 
and _regimen=Confirmed;
;

quit;


PROC SGPLOT Data = wantQc;
    scatter x = Date   y = 'Province/State'n;
	refline 'Province/State'n /axis= y;
	refline Date /axis= x;
/*	group= 'Country/Region'n, 'Province/State'n */
/*	groupdisplay=cluster lineattrs=(color=black);*/
    title "First Case in Canada Provinces";
run;












