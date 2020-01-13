-- [ 1] Africa
-- [ 2] Americas - Central and Southern
-- [ 3] Americas - Northern
-- [ 4] Asia - Central and South-Eastern
-- [ 5] Asia - Eastern
-- [ 6] Asia - Southern and Western
-- [ 7] Australia and New Zealand
-- [ 8] Europe
-- [ 9] Europe - Eastern
-- [10] Other

select
1 "id",
'Africa' "name",
'USD' "blockchain_ecpm_currency", 500 "blockchain_ecpm_cents",
'USD' "css_and_design_ecpm_currency", 500 "css_and_design_ecpm_cents",
'USD' "dev_ops_ecpm_currency", 500 "dev_ops_ecpm_cents",
'USD' "game_development_ecpm_currency", 500 "game_development_ecpm_cents",
'USD' "javascript_and_frontend_ecpm_currency", 500 "javascript_and_frontend_ecpm_cents",
'USD' "miscellaneous_ecpm_currency", 500 "miscellaneous_ecpm_cents",
'USD' "mobile_development_ecpm_currency", 500 "mobile_development_ecpm_cents",
'USD' "web_development_and_backend_ecpm_currency", 500 "web_development_and_backend_ecpm_cents",
'{AO,BF,BI,BJ,BW,CD,CF,CG,CI,CM,CV,DJ,DZ,EG,EH,ER,ET,GA,GH,GM,GN,GQ,GW,IO,KE,KM,LR,LS,LY,MA,MG,ML,MR,MU,MW,MZ,NA,NE,NG,RE,RW,SC,SD,SH,SL,SN,SO,SS,ST,SZ,TD,TG,TN,TZ,UG,YT,ZA,ZM,ZW}'::text[] "country_codes"

union all

select
2 "id",
'Americas - Central and Southern',
'USD', 500, -- blockchain
'USD', 500, -- css_and_design
'USD', 500, -- dev_ops
'USD', 500, -- game_development
'USD', 500, -- javascript_and_frontend
'USD', 500, -- miscellaneous
'USD', 500, -- mobile_development
'USD', 500, -- web_development_and_backend
'{AR,BO,BR,BZ,CL,CO,CR,EC,FK,GF,GS,GT,GY,HN,MX,NI,PA,PE,PY,SR,SV,UY,VE}'::text[]

union all

select
3 "id",
'Americas - Northern' "name",
'USD', 500, -- blockchain
'USD', 500, -- css_and_design
'USD', 500, -- dev_ops
'USD', 500, -- game_development
'USD', 500, -- javascript_and_frontend
'USD', 500, -- miscellaneous
'USD', 500, -- mobile_development
'USD', 500, -- web_development_and_backend
'{US,CA}'::text[] "country_codes"

union all

select
4 "id",
'Asia - Central and South-Eastern',
'USD', 500, -- blockchain
'USD', 500, -- css_and_design
'USD', 500, -- dev_ops
'USD', 500, -- game_development
'USD', 500, -- javascript_and_frontend
'USD', 500, -- miscellaneous
'USD', 500, -- mobile_development
'USD', 500, -- web_development_and_backend
'{BN,ID,KG,KH,KZ,LA,MM,MY,PH,SG,TH,TJ,TL,TM,UZ,VN}'::text[]

union all

select
5 "id",
'Asia - Eastern',
'USD', 500, -- blockchain
'USD', 500, -- css_and_design
'USD', 500, -- dev_ops
'USD', 500, -- game_development
'USD', 500, -- javascript_and_frontend
'USD', 500, -- miscellaneous
'USD', 500, -- mobile_development
'USD', 500, -- web_development_and_backend
'{CN,HK,JP,KP,KR,MN,MO,TW}'::text[]

union all

select
6 "id",
'Asia - Southern and Western',
'USD', 500, -- blockchain
'USD', 500, -- css_and_design
'USD', 500, -- dev_ops
'USD', 500, -- game_development
'USD', 500, -- javascript_and_frontend
'USD', 500, -- miscellaneous
'USD', 500, -- mobile_development
'USD', 500, -- web_development_and_backend
'{AE,AF,AM,AZ,BD,BH,BT,CY,GE,IL,IN,IQ,IR,JO,KW,LB,LK,MV,NP,OM,PK,PS,QA,SA,SY,TR,YE}'::text[]

union all

select
7 "id",
'Australia and New Zealand' "name",
'USD', 500, -- blockchain
'USD', 500, -- css_and_design
'USD', 500, -- dev_ops
'USD', 500, -- game_development
'USD', 500, -- javascript_and_frontend
'USD', 500, -- miscellaneous
'USD', 500, -- mobile_development
'USD', 500, -- web_development_and_backend
'{AU,CC,CX,NF,NZ}'::text[]

union all

select
8 "id",
'Europe',
'USD', 500, -- blockchain
'USD', 500, -- css_and_design
'USD', 500, -- dev_ops
'USD', 500, -- game_development
'USD', 500, -- javascript_and_frontend
'USD', 500, -- miscellaneous
'USD', 500, -- mobile_development
'USD', 500, -- web_development_and_backend
'{AD,AL,AT,AX,BA,BE,CH,DE,DK,EE,ES,FI,FO,FR,GB,GG,GI,GR,HR,IE,IM,IS,IT,JE,LI,LT,LU,LV,MC,ME,MK,MT,NL,NO,PT,RS,SE,SI,SJ,SM,VA}'::text[]

union all

select
9 "id",
'Europe - Eastern',
'USD', 500, -- blockchain
'USD', 500, -- css_and_design
'USD', 500, -- dev_ops
'USD', 500, -- game_development
'USD', 500, -- javascript_and_frontend
'USD', 500, -- miscellaneous
'USD', 500, -- mobile_development
'USD', 500, -- web_development_and_backend
'{BG,BY,CZ,HU,MD,PL,RO,RU,SK,UA}'::text[]

union all

select
10,
'Other',
'USD', 600, -- blockchain
'USD', 50,  -- css and design
'USD', 250, -- dev ops
'USD', 25,  -- game development
'USD', 225, -- javascript
'USD', 25,  -- miscellaneous
'USD', 50,  -- mobile development
'USD', 100, -- web development
'{AG,AI,AS,AW,BB,BL,BM,BQ,BS,CK,CU,CW,DM,DO,FJ,FM,GD,GL,GP,GU,HT,JM,KI,KN,KY,LC,MF,MH,MP,MQ,MS,NC,NR,NU,PF,PG,PM,PN,PR,PW,SB,SX,TC,TK,TO,TT,TV,UM,VC,VG,VI,VU,WF,WS}'::text[]
