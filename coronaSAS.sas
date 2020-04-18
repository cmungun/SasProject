
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
	and
		('Province/State'n ='Q'
    or	'Province/State'n ='Q'
		)
	)
);
Run;
Data libraryy.dataset;
Set libraryy.dataset;
 Zero = 0;
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





