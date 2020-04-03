-- 
-- Legal Notice 
-- 
-- This document and associated source code (the "Work") is a part of a 
-- benchmark specification maintained by the TPC. 
-- 
-- The TPC reserves all right, title, and interest to the Work as provided 
-- under U.S. and international laws, including without limitation all patent 
-- and trademark rights therein. 
-- 
-- No Warranty 
-- 
-- 1.1 TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW, THE INFORMATION 
--     NULLABLE(CONTAINED) HEREIN IS PROVIDED "AS IS" AND WITH ALL FAULTS, AND THE 
--     NULLABLE(AUTHORS) AND DEVELOPERS OF THE WORK HEREBY DISCLAIM ALL OTHER 
--     NULLABLE(WARRANTIES) AND CONDITIONS, EITHER EXPRESS, IMPLIED OR STATUTORY, 
--     NULLABLE(INCLUDING) BUT NOT LIMITED TO, ANY (IF ANY) IMPLIED WARRANTIES, 
--     NULLABLE(DUTIES) OR CONDITIONS OF MERCHANTABILITY, OF FITNESS FOR A PARTICULAR 
--     NULLABLE(PURPOSE) OF ACCURACY OR COMPLETENESS OF RESPONSES, OF RESULTS, OF 
--     NULLABLE(WORKMANLIKE) EFFORT, OF LACK OF VIRUSES, AND OF LACK OF NEGLIGENCE. 
--     NULLABLE(ALSO) THERE IS NO WARRANTY OR CONDITION OF TITLE, QUIET ENJOYMENT, 
--     NULLABLE(QUIET) POSSESSION, CORRESPONDENCE TO DESCRIPTION OR NON-INFRINGEMENT 
--     NULLABLE(WITH) REGARD TO THE WORK. 
-- 1.2 IN NO EVENT WILL ANY AUTHOR OR DEVELOPER OF THE WORK BE LIABLE TO 
--     NULLABLE(ANY) OTHER PARTY FOR ANY DAMAGES, INCLUDING BUT NOT LIMITED TO THE 
--     NULLABLE(COST) OF PROCURING SUBSTITUTE GOODS OR SERVICES, LOST PROFITS, LOSS 
--     NULLABLE(OF) USE, LOSS OF DATA, OR ANY INCIDENTAL, CONSEQUENTIAL, DIRECT, 
--     NULLABLE(INDIRECT) OR SPECIAL DAMAGES WHETHER UNDER CONTRACT, TORT, WARRANTY,
--     NULLABLE(OR) OTHERWISE, ARISING IN ANY WAY OUT OF THIS OR ANY OTHER AGREEMENT 
--     NULLABLE(RELATING) TO THE WORK, WHETHER OR NOT SUCH AUTHOR OR DEVELOPER HAD 
--     NULLABLE(ADVANCE) NOTICE OF THE POSSIBILITY OF SUCH DAMAGES. 
-- 
-- Contributors:
-- Gradient Systems
--


-- Notes for CH SQL, the update to tools/tpcds.sql
--   1. Create database and use it
--   2. Update column data type:
--     Nullable(varchar) -> String
--     Nullable(char(\d) -> FixedString(\d+)
--     Nullable(integer) -> Int64
--     Nullable(decimail() -> Float64
--     Nullable(date) -> Date
--     Nullable(time) -> DateTime
--   3. Engine is MergeTree
--   4. Index_granularity is 8192
--   5. Replace pramary key with order by
--   6. If there is Date column, use as partition by,
--     Nullable(else) no partition by with one exception in customer table
--   7. Other minor update to fix syntax error like delete ending comma
--
-- May need to make adjustment to improve efficiency

drop database tpcds1g;
CREATE DATABASE tpcds1g;
use tpcds1g;

-- Don't need this table
-- create table dbgen_version
-- (
--     dv_version Nullable(String),
--     dv_create_date Date,
--     dv_create_time Nullable(DateTime),
--     dv_cmdline_args Nullable(String)                  
-- ) ENGINE=MergeTree()
--   Partition By toYYYYMM(dv_create_date)
--   ORDER By (dv_create_date)
--   SETTINGS index_granularity = 8192;

create table customer_address
(
    ca_address_sk Int64,
    ca_address_id Nullable(FixedString(16)),
    ca_street_number Nullable(FixedString(10)),
    ca_street_name Nullable(String),
    ca_street_type Nullable(FixedString(15)),
    ca_suite_number Nullable(FixedString(10)),
    ca_city Nullable(String),
    ca_county Nullable(String),
    ca_state Nullable(FixedString(2)),
    ca_zip Nullable(FixedString(10)),
    ca_country Nullable(String),
    ca_gmt_offset Nullable(Float64),
    ca_location_type Nullable(FixedString(20))                      
) ENGINE=MergeTree()
  Partition by assumeNotNull(ca_location_type)
  ORDER By (ca_address_sk)
  SETTINGS index_granularity = 8192;

create table customer_demographics
(
    cd_demo_sk Int64,
    cd_gender Nullable(FixedString(1)),
    cd_marital_status Nullable(FixedString(1)),
    cd_education_status Nullable(FixedString(20)),
    cd_purchase_estimate Nullable(Int64),
    cd_credit_rating Nullable(FixedString(10)),
    cd_dep_count Nullable(Int64),
    cd_dep_employed_count Nullable(Int64),
    cd_dep_college_count Nullable(Int64)                       
) ENGINE=MergeTree()
  Partition by assumeNotNull(cd_marital_status)
  ORDER By (cd_demo_sk)
  SETTINGS index_granularity = 8192;

create table date_dim
(
    d_date_sk Int64,
    d_date_id Nullable(FixedString(16)),
    d_date Nullable(Date),
    d_month_seq Nullable(Int64),
    d_week_seq Nullable(Int64),
    d_quarter_seq Nullable(Int64),
    d_year Nullable(Int64),
    d_dow Nullable(Int64),
    d_moy Nullable(Int64),
    d_dom Nullable(Int64),
    d_qoy Nullable(Int64),
    d_fy_year Nullable(Int64),
    d_fy_quarter_seq Nullable(Int64),
    d_fy_week_seq Nullable(Int64),
    d_day_name Nullable(FixedString(9)),
    d_quarter_name Nullable(FixedString(6)),
    d_holiday Nullable(FixedString(1)),
    d_weekend Nullable(FixedString(1)),
    d_following_holiday Nullable(FixedString(1)),
    d_first_dom Nullable(Int64),
    d_last_dom Nullable(Int64),
    d_same_day_ly Nullable(Int64),
    d_same_day_lq Nullable(Int64),
    d_current_day Nullable(FixedString(1)),
    d_current_week Nullable(FixedString(1)),
    d_current_month Nullable(FixedString(1)),
    d_current_quarter Nullable(FixedString(1)),
    d_current_year Nullable(FixedString(1))                       
) ENGINE=MergeTree()
  ORDER By (d_date_sk)
  SETTINGS index_granularity = 8192;

create table warehouse
(
    w_warehouse_sk Int64,
    w_warehouse_id Nullable(FixedString(16)),
    w_warehouse_name Nullable(String),
    w_warehouse_sq_ft Nullable(Int64),
    w_street_number Nullable(FixedString(10)),
    w_street_name Nullable(String),
    w_street_type Nullable(FixedString(15)),
    w_suite_number Nullable(FixedString(10)),
    w_city Nullable(String),
    w_county Nullable(String),
    w_state Nullable(FixedString(2)),
    w_zip Nullable(FixedString(10)),
    w_country Nullable(String),
    w_gmt_offset Nullable(Float64)                  
) ENGINE=MergeTree()
  ORDER By (w_warehouse_sk)
  SETTINGS index_granularity = 8192;

create table ship_mode
(
    sm_ship_mode_sk Int64,
    sm_ship_mode_id Nullable(FixedString(16)),
    sm_type Nullable(FixedString(30)),
    sm_code Nullable(FixedString(10)),
    sm_carrier Nullable(FixedString(20)),
    sm_contract Nullable(FixedString(20))                      
) ENGINE=MergeTree()
  ORDER By (sm_ship_mode_sk)
  SETTINGS index_granularity = 8192;

create table time_dim
(
    t_time_sk Int64,
    t_time_id Nullable(FixedString(16)),
    t_time Nullable(Int64),
    t_hour Nullable(Int64),
    t_minute Nullable(Int64),
    t_second Nullable(Int64),
    t_am_pm Nullable(FixedString(2)),
    t_shift Nullable(FixedString(20)),
    t_sub_shift Nullable(FixedString(20)),
    t_meal_time Nullable(FixedString(20))                      
) ENGINE=MergeTree()
  ORDER By (t_time_sk)
  SETTINGS index_granularity = 8192;

create table reason
(
    r_reason_sk Int64,
    r_reason_id Nullable(FixedString(16)),
    r_reason_desc Nullable(FixedString(100))                     
) ENGINE=MergeTree()
  ORDER By (r_reason_sk)
  SETTINGS index_granularity = 8192;

create table income_band
(
    ib_income_band_sk Int64,
    ib_lower_bound Nullable(Int64),
    ib_upper_bound Nullable(Int64)                       
) ENGINE=MergeTree()
  ORDER By (ib_income_band_sk)
  SETTINGS index_granularity = 8192;

create table item
(
    i_item_sk Int64,
    i_item_id Nullable(FixedString(16)),
    i_rec_start_date Nullable(Date),
    i_rec_end_date Nullable(Date),
    i_item_desc Nullable(String),
    i_current_price Nullable(Float64),
    i_wholesale_cost Nullable(Float64),
    i_brand_id Nullable(Int64),
    i_brand Nullable(FixedString(50)),
    i_class_id Nullable(Int64),
    i_class Nullable(FixedString(50)),
    i_category_id Nullable(Int64),
    i_category Nullable(FixedString(50)),
    i_manufact_id Nullable(Int64),
    i_manufact Nullable(FixedString(50)),
    i_size Nullable(FixedString(20)),
    i_formulation Nullable(FixedString(20)),
    i_color Nullable(FixedString(20)),
    i_units Nullable(FixedString(10)),
    i_container Nullable(FixedString(10)),
    i_manager_id Nullable(Int64),
    i_product_name Nullable(FixedString(50))                      
) ENGINE=MergeTree()
  ORDER By (i_item_sk)
  SETTINGS index_granularity = 8192;

create table store
(
    s_store_sk Int64,
    s_store_id Nullable(FixedString(16)),
    s_rec_start_date Date,
    s_rec_end_date Nullable(Date),
    s_closed_date_sk Nullable(Int64),
    s_store_name Nullable(String),
    s_number_employees Nullable(Int64),
    s_floor_space Nullable(Int64),
    s_hours Nullable(FixedString(20)),
    s_manager Nullable(String),
    s_market_id Nullable(Int64),
    s_geography_class Nullable(String),
    s_market_desc Nullable(String),
    s_market_manager Nullable(String),
    s_division_id Nullable(Int64),
    s_division_name Nullable(String),
    s_company_id Nullable(Int64),
    s_company_name Nullable(String),
    s_street_number Nullable(String),
    s_street_name Nullable(String),
    s_street_type Nullable(FixedString(15)),
    s_suite_number Nullable(FixedString(10)),
    s_city Nullable(String),
    s_county Nullable(String),
    s_state Nullable(FixedString(2)),
    s_zip Nullable(FixedString(10)),
    s_country Nullable(String),
    s_gmt_offset Nullable(Float64),
    s_tax_precentage Nullable(Float64)                  
) ENGINE=MergeTree()
  Partition By toYYYYMM(s_rec_start_date)
  ORDER By (s_store_sk)
  SETTINGS index_granularity = 8192;

create table call_center
(
    cc_call_center_sk Int64,
    cc_call_center_id Nullable(FixedString(16)),
    cc_rec_start_date Date,
    cc_rec_end_date Nullable(Date),
    cc_closed_date_sk Nullable(Int64),
    cc_open_date_sk Nullable(Int64),
    cc_name Nullable(String),
    cc_class Nullable(String),
    cc_employees Nullable(Int64),
    cc_sq_ft Nullable(Int64),
    cc_hours Nullable(FixedString(20)),
    cc_manager Nullable(String),
    cc_mkt_id Nullable(Int64),
    cc_mkt_class Nullable(FixedString(50)),
    cc_mkt_desc Nullable(String),
    cc_market_manager Nullable(String),
    cc_division Nullable(Int64),
    cc_division_name Nullable(String),
    cc_company Nullable(Int64),
    cc_company_name Nullable(FixedString(50)),
    cc_street_number Nullable(FixedString(10)),
    cc_street_name Nullable(String),
    cc_street_type Nullable(FixedString(15)),
    cc_suite_number Nullable(FixedString(10)),
    cc_city Nullable(String),
    cc_county Nullable(String),
    cc_state Nullable(FixedString(2)),
    cc_zip Nullable(FixedString(10)),
    cc_country Nullable(String),
    cc_gmt_offset Nullable(Float64),
    cc_tax_percentage Nullable(Float64)                  
) ENGINE=MergeTree()
  Partition By toYYYYMM(cc_rec_start_date)
  ORDER By (cc_call_center_sk)
  SETTINGS index_granularity = 8192;

create table customer
(
    c_customer_sk Int64,
    c_customer_id Nullable(FixedString(16)),
    c_current_cdemo_sk Nullable(Int64),
    c_current_hdemo_sk Nullable(Int64),
    c_current_addr_sk Nullable(Int64),
    c_first_shipto_date_sk Nullable(Int64),
    c_first_sales_date_sk Nullable(Int64),
    c_salutation Nullable(FixedString(10)),
    c_first_name Nullable(FixedString(20)),
    c_last_name Nullable(FixedString(30)),
    c_preferred_cust_flag Nullable(FixedString(1)),
    c_birth_day Nullable(Int64),
    c_birth_month Nullable(Int64),
    c_birth_year Nullable(Int64),
    c_birth_country Nullable(String),
    c_login Nullable(FixedString(13)),
    c_email_address Nullable(FixedString(50)),
    c_last_review_date_sk Nullable(Int64)                       
) ENGINE=MergeTree()
  ORDER By (c_customer_sk)
  SETTINGS index_granularity = 8192;

create table web_site
(
    web_site_sk Int64,
    web_site_id Nullable(FixedString(16)),
    web_rec_start_date Date,
    web_rec_end_date Nullable(Date),
    web_name Nullable(String),
    web_open_date_sk Nullable(Int64),
    web_close_date_sk Nullable(Int64),
    web_class Nullable(String),
    web_manager Nullable(String),
    web_mkt_id Nullable(Int64),
    web_mkt_class Nullable(String),
    web_mkt_desc Nullable(String),
    web_market_manager Nullable(String),
    web_company_id Nullable(Int64),
    web_company_name Nullable(FixedString(50)),
    web_street_number Nullable(FixedString(10)),
    web_street_name Nullable(String),
    web_street_type Nullable(FixedString(15)),
    web_suite_number Nullable(FixedString(10)),
    web_city Nullable(String),
    web_county Nullable(String),
    web_state Nullable(FixedString(2)),
    web_zip Nullable(FixedString(10)),
    web_country Nullable(String),
    web_gmt_offset Nullable(Float64),
    web_tax_percentage Nullable(Float64)                  
) ENGINE=MergeTree()
  Partition By toYYYYMM(web_rec_start_date)
  ORDER By (web_site_sk)
  SETTINGS index_granularity = 8192;

create table store_returns
(
    sr_returned_date_sk Nullable(Int64),
    sr_return_time_sk Nullable(Int64),
    sr_item_sk Int64,
    sr_customer_sk Nullable(Int64),
    sr_cdemo_sk Nullable(Int64),
    sr_hdemo_sk Nullable(Int64),
    sr_addr_sk Nullable(Int64),
    sr_store_sk Nullable(Int64),
    sr_reason_sk Nullable(Int64),
    sr_ticket_number Int64,
    sr_return_quantity Nullable(Int64),
    sr_return_amt Nullable(Float64),
    sr_return_tax Nullable(Float64),
    sr_return_amt_inc_tax Nullable(Float64),
    sr_fee Nullable(Float64),
    sr_return_ship_cost Nullable(Float64),
    sr_refunded_cash Nullable(Float64),
    sr_reversed_charge Nullable(Float64),
    sr_store_credit Nullable(Float64),
    sr_net_loss Nullable(Float64)                  
) ENGINE=MergeTree()
  ORDER By (sr_item_sk, sr_ticket_number)
  SETTINGS index_granularity = 8192;

create table household_demographics
(
    hd_demo_sk Int64,
    hd_income_band_sk Nullable(Int64),
    hd_buy_potential Nullable(FixedString(15)),
    hd_dep_count Nullable(Int64),
    hd_vehicle_count Nullable(Int64)                       
) ENGINE=MergeTree()
  ORDER By (hd_demo_sk)
  SETTINGS index_granularity = 8192;

create table web_page
(
    wp_web_page_sk Int64,
    wp_web_page_id Nullable(FixedString(16)),
    wp_rec_start_date Date,
    wp_rec_end_date Nullable(Date),
    wp_creation_date_sk Nullable(Int64),
    wp_access_date_sk Nullable(Int64),
    wp_autogen_flag Nullable(FixedString(1)),
    wp_customer_sk Nullable(Int64),
    wp_url Nullable(String),
    wp_type Nullable(FixedString(50)),
    wp_char_count Nullable(Int64),
    wp_link_count Nullable(Int64),
    wp_image_count Nullable(Int64),
    wp_max_ad_count Nullable(Int64)                       
) ENGINE=MergeTree()
  Partition By toYYYYMM(wp_rec_start_date)
  ORDER By (wp_web_page_sk)
  SETTINGS index_granularity = 8192;

create table promotion
(
    p_promo_sk Int64,
    p_promo_id Nullable(FixedString(16)),
    p_start_date_sk Nullable(Int64),
    p_end_date_sk Nullable(Int64),
    p_item_sk Nullable(Int64),
    p_cost Nullable(Float64),
    p_response_target Nullable(Int64),
    p_promo_name Nullable(FixedString(50)),
    p_channel_dmail Nullable(FixedString(1)),
    p_channel_email Nullable(FixedString(1)),
    p_channel_catalog Nullable(FixedString(1)),
    p_channel_tv Nullable(FixedString(1)),
    p_channel_radio Nullable(FixedString(1)),
    p_channel_press Nullable(FixedString(1)),
    p_channel_event Nullable(FixedString(1)),
    p_channel_demo Nullable(FixedString(1)),
    p_channel_details Nullable(String),
    p_purpose Nullable(FixedString(15)),
    p_discount_active Nullable(FixedString(1))                       
) ENGINE=MergeTree()
  ORDER By (p_promo_sk)
  SETTINGS index_granularity = 8192;

create table catalog_page
(
    cp_catalog_page_sk Int64,
    cp_catalog_page_id Nullable(FixedString(16)),
    cp_start_date_sk Nullable(Int64),
    cp_end_date_sk Nullable(Int64),
    cp_department Nullable(String),
    cp_catalog_number Nullable(Int64),
    cp_catalog_page_number Nullable(Int64),
    cp_description Nullable(String),
    cp_type Nullable(String)                  
) ENGINE=MergeTree()
  ORDER By (cp_catalog_page_sk)
  SETTINGS index_granularity = 8192;

create table inventory
(
    inv_date_sk Int64,
    inv_item_sk Int64,
    inv_warehouse_sk Int64,
    inv_quantity_on_hand Nullable(Int64)                       
) ENGINE=MergeTree()
  ORDER By (inv_date_sk, inv_item_sk, inv_warehouse_sk)
  SETTINGS index_granularity = 8192;

create table catalog_returns
(
    cr_returned_date_sk Nullable(Int64),
    cr_returned_time_sk Nullable(Int64),
    cr_item_sk Int64,
    cr_refunded_customer_sk Nullable(Int64),
    cr_refunded_cdemo_sk Nullable(Int64),
    cr_refunded_hdemo_sk Nullable(Int64),
    cr_refunded_addr_sk Nullable(Int64),
    cr_returning_customer_sk Nullable(Int64),
    cr_returning_cdemo_sk Nullable(Int64),
    cr_returning_hdemo_sk Nullable(Int64),
    cr_returning_addr_sk Nullable(Int64),
    cr_call_center_sk Nullable(Int64),
    cr_catalog_page_sk Nullable(Int64),
    cr_ship_mode_sk Nullable(Int64),
    cr_warehouse_sk Nullable(Int64),
    cr_reason_sk Nullable(Int64),
    cr_order_number Int64,
    cr_return_quantity Nullable(Int64),
    cr_return_amount Nullable(Float64),
    cr_return_tax Nullable(Float64),
    cr_return_amt_inc_tax Nullable(Float64),
    cr_fee Nullable(Float64),
    cr_return_ship_cost Nullable(Float64),
    cr_refunded_cash Nullable(Float64),
    cr_reversed_charge Nullable(Float64),
    cr_store_credit Nullable(Float64),
    cr_net_loss Nullable(Float64)                  
) ENGINE=MergeTree()
  ORDER By (cr_item_sk, cr_order_number)
  SETTINGS index_granularity = 8192;

create table web_returns
(
    wr_returned_date_sk Nullable(Int64),
    wr_returned_time_sk Nullable(Int64),
    wr_item_sk Int64,
    wr_refunded_customer_sk Nullable(Int64),
    wr_refunded_cdemo_sk Nullable(Int64),
    wr_refunded_hdemo_sk Nullable(Int64),
    wr_refunded_addr_sk Nullable(Int64),
    wr_returning_customer_sk Nullable(Int64),
    wr_returning_cdemo_sk Nullable(Int64),
    wr_returning_hdemo_sk Nullable(Int64),
    wr_returning_addr_sk Nullable(Int64),
    wr_web_page_sk Nullable(Int64),
    wr_reason_sk Nullable(Int64),
    wr_order_number Int64,
    wr_return_quantity Nullable(Int64),
    wr_return_amt Nullable(Float64),
    wr_return_tax Nullable(Float64),
    wr_return_amt_inc_tax Nullable(Float64),
    wr_fee Nullable(Float64),
    wr_return_ship_cost Nullable(Float64),
    wr_refunded_cash Nullable(Float64),
    wr_reversed_charge Nullable(Float64),
    wr_account_credit Nullable(Float64),
    wr_net_loss Nullable(Float64)                  
) ENGINE=MergeTree()
  ORDER By (wr_item_sk, wr_order_number)
  SETTINGS index_granularity = 8192;

create table web_sales
(
    ws_sold_date_sk Nullable(Int64),
    ws_sold_time_sk Nullable(Int64),
    ws_ship_date_sk Nullable(Int64),
    ws_item_sk Int64,
    ws_bill_customer_sk Nullable(Int64),
    ws_bill_cdemo_sk Nullable(Int64),
    ws_bill_hdemo_sk Nullable(Int64),
    ws_bill_addr_sk Nullable(Int64),
    ws_ship_customer_sk Nullable(Int64),
    ws_ship_cdemo_sk Nullable(Int64),
    ws_ship_hdemo_sk Nullable(Int64),
    ws_ship_addr_sk Nullable(Int64),
    ws_web_page_sk Nullable(Int64),
    ws_web_site_sk Nullable(Int64),
    ws_ship_mode_sk Nullable(Int64),
    ws_warehouse_sk Nullable(Int64),
    ws_promo_sk Nullable(Int64),
    ws_order_number Int64,
    ws_quantity Nullable(Int64),
    ws_wholesale_cost Nullable(Float64),
    ws_list_price Nullable(Float64),
    ws_sales_price Nullable(Float64),
    ws_ext_discount_amt Nullable(Float64),
    ws_ext_sales_price Nullable(Float64),
    ws_ext_wholesale_cost Nullable(Float64),
    ws_ext_list_price Nullable(Float64),
    ws_ext_tax Nullable(Float64),
    ws_coupon_amt Nullable(Float64),
    ws_ext_ship_cost Nullable(Float64),
    ws_net_paid Nullable(Float64),
    ws_net_paid_inc_tax Nullable(Float64),
    ws_net_paid_inc_ship Nullable(Float64),
    ws_net_paid_inc_ship_tax Nullable(Float64),
    ws_net_profit Nullable(Float64)                  
) ENGINE=MergeTree()
  ORDER By (ws_item_sk, ws_order_number)
  SETTINGS index_granularity = 8192;

create table catalog_sales
(
    cs_sold_date_sk Nullable(Int64),
    cs_sold_time_sk Nullable(Int64),
    cs_ship_date_sk Nullable(Int64),
    cs_bill_customer_sk Nullable(Int64),
    cs_bill_cdemo_sk Nullable(Int64),
    cs_bill_hdemo_sk Nullable(Int64),
    cs_bill_addr_sk Nullable(Int64),
    cs_ship_customer_sk Nullable(Int64),
    cs_ship_cdemo_sk Nullable(Int64),
    cs_ship_hdemo_sk Nullable(Int64),
    cs_ship_addr_sk Nullable(Int64),
    cs_call_center_sk Nullable(Int64),
    cs_catalog_page_sk Nullable(Int64),
    cs_ship_mode_sk Nullable(Int64),
    cs_warehouse_sk Nullable(Int64),
    cs_item_sk Int64,
    cs_promo_sk Nullable(Int64),
    cs_order_number Int64,
    cs_quantity Nullable(Int64),
    cs_wholesale_cost Nullable(Float64),
    cs_list_price Nullable(Float64),
    cs_sales_price Nullable(Float64),
    cs_ext_discount_amt Nullable(Float64),
    cs_ext_sales_price Nullable(Float64),
    cs_ext_wholesale_cost Nullable(Float64),
    cs_ext_list_price Nullable(Float64),
    cs_ext_tax Nullable(Float64),
    cs_coupon_amt Nullable(Float64),
    cs_ext_ship_cost Nullable(Float64),
    cs_net_paid Nullable(Float64),
    cs_net_paid_inc_tax Nullable(Float64),
    cs_net_paid_inc_ship Nullable(Float64),
    cs_net_paid_inc_ship_tax Nullable(Float64),
    cs_net_profit Nullable(Float64)                  
) ENGINE=MergeTree()
  ORDER By (cs_item_sk, cs_order_number)
  SETTINGS index_granularity = 8192;

create table store_sales
(
    ss_sold_date_sk Nullable(Int64),
    ss_sold_time_sk Nullable(Int64),
    ss_item_sk Int64,
    ss_customer_sk Nullable(Int64),
    ss_cdemo_sk Nullable(Int64),
    ss_hdemo_sk Nullable(Int64),
    ss_addr_sk Nullable(Int64),
    ss_store_sk Nullable(Int64),
    ss_promo_sk Nullable(Int64),
    ss_ticket_number Int64,
    ss_quantity Nullable(Int64),
    ss_wholesale_cost Nullable(Float64),
    ss_list_price Nullable(Float64),
    ss_sales_price Nullable(Float64),
    ss_ext_discount_amt Nullable(Float64),
    ss_ext_sales_price Nullable(Float64),
    ss_ext_wholesale_cost Nullable(Float64),
    ss_ext_list_price Nullable(Float64),
    ss_ext_tax Nullable(Float64),
    ss_coupon_amt Nullable(Float64),
    ss_net_paid Nullable(Float64),
    ss_net_paid_inc_tax Nullable(Float64),
    ss_net_profit Nullable(Float64)                  
) ENGINE=MergeTree()
  ORDER By (ss_item_sk, ss_ticket_number)
  SETTINGS index_granularity = 8192;
