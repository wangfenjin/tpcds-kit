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
--     CONTAINED HEREIN IS PROVIDED "AS IS" AND WITH ALL FAULTS, AND THE 
--     AUTHORS AND DEVELOPERS OF THE WORK HEREBY DISCLAIM ALL OTHER 
--     WARRANTIES AND CONDITIONS, EITHER EXPRESS, IMPLIED OR STATUTORY, 
--     INCLUDING, BUT NOT LIMITED TO, ANY (IF ANY) IMPLIED WARRANTIES, 
--     DUTIES OR CONDITIONS OF MERCHANTABILITY, OF FITNESS FOR A PARTICULAR 
--     PURPOSE, OF ACCURACY OR COMPLETENESS OF RESPONSES, OF RESULTS, OF 
--     WORKMANLIKE EFFORT, OF LACK OF VIRUSES, AND OF LACK OF NEGLIGENCE. 
--     ALSO, THERE IS NO WARRANTY OR CONDITION OF TITLE, QUIET ENJOYMENT, 
--     QUIET POSSESSION, CORRESPONDENCE TO DESCRIPTION OR NON-INFRINGEMENT 
--     WITH REGARD TO THE WORK. 
-- 1.2 IN NO EVENT WILL ANY AUTHOR OR DEVELOPER OF THE WORK BE LIABLE TO 
--     ANY OTHER PARTY FOR ANY DAMAGES, INCLUDING BUT NOT LIMITED TO THE 
--     COST OF PROCURING SUBSTITUTE GOODS OR SERVICES, LOST PROFITS, LOSS 
--     OF USE, LOSS OF DATA, OR ANY INCIDENTAL, CONSEQUENTIAL, DIRECT, 
--     INDIRECT, OR SPECIAL DAMAGES WHETHER UNDER CONTRACT, TORT, WARRANTY,
--     OR OTHERWISE, ARISING IN ANY WAY OUT OF THIS OR ANY OTHER AGREEMENT 
--     RELATING TO THE WORK, WHETHER OR NOT SUCH AUTHOR OR DEVELOPER HAD 
--     ADVANCE NOTICE OF THE POSSIBILITY OF SUCH DAMAGES. 
-- 
-- Contributors:
-- Gradient Systems
--


-- Notes for CH SQL, the update to tools/tpcds.sql
--   1. Create database and use it
--   2. Update column data type:
--      * varchar -> String
--      * char(\d+) -> FixedString(\d+)
--      * integer -> Int64
--      * decimail(.*) -> Float64
--      * date -> Date
--      * time -> DateTime
--   3. Engine is MergeTree
--   4. Index_granularity is 8192
--   5. Replace pramary key with order by
--   6. If there is Date column, use as partition by,
--      else no partition by with one exception in customer table
--   7. Other minor update to fix syntax error like delete ending comma
--
-- May need to make adjustment to improve efficiency

CREATE DATABASE tpcds1g;
use tpcds1g;

create table dbgen_version
(
    dv_version                String                   ,
    dv_create_date            Date                          ,
    dv_create_time            DateTime                          ,
    dv_cmdline_args           String                  
) ENGINE=MergeTree()
  Partition By toYYYYMM(dv_create_date)
  ORDER By (dv_create_date)
  SETTINGS index_granularity = 8192;

create table customer_address
(
    ca_address_sk             Int64              ,
    ca_address_id             FixedString(16)             ,
    ca_street_number          FixedString(10)                      ,
    ca_street_name            String                   ,
    ca_street_type            FixedString(15)                      ,
    ca_suite_number           FixedString(10)                      ,
    ca_city                   String                   ,
    ca_county                 String                   ,
    ca_state                  FixedString(2)                       ,
    ca_zip                    FixedString(10)                      ,
    ca_country                String                   ,
    ca_gmt_offset             Float64                  ,
    ca_location_type          FixedString(20)                      
) ENGINE=MergeTree()
  ORDER By (ca_address_sk)
  SETTINGS index_granularity = 8192;

create table customer_demographics
(
    cd_demo_sk                Int64              ,
    cd_gender                 FixedString(1)                       ,
    cd_marital_status         FixedString(1)                       ,
    cd_education_status       FixedString(20)                      ,
    cd_purchase_estimate      Int64                       ,
    cd_credit_rating          FixedString(10)                      ,
    cd_dep_count              Int64                       ,
    cd_dep_employed_count     Int64                       ,
    cd_dep_college_count      Int64                       
) ENGINE=MergeTree()
  ORDER By (cd_demo_sk)
  SETTINGS index_granularity = 8192;

create table date_dim
(
    d_date_sk                 Int64              ,
    d_date_id                 FixedString(16)             ,
    d_date                    Date                          ,
    d_month_seq               Int64                       ,
    d_week_seq                Int64                       ,
    d_quarter_seq             Int64                       ,
    d_year                    Int64                       ,
    d_dow                     Int64                       ,
    d_moy                     Int64                       ,
    d_dom                     Int64                       ,
    d_qoy                     Int64                       ,
    d_fy_year                 Int64                       ,
    d_fy_quarter_seq          Int64                       ,
    d_fy_week_seq             Int64                       ,
    d_day_name                FixedString(9)                       ,
    d_quarter_name            FixedString(6)                       ,
    d_holiday                 FixedString(1)                       ,
    d_weekend                 FixedString(1)                       ,
    d_following_holiday       FixedString(1)                       ,
    d_first_dom               Int64                       ,
    d_last_dom                Int64                       ,
    d_same_day_ly             Int64                       ,
    d_same_day_lq             Int64                       ,
    d_current_day             FixedString(1)                       ,
    d_current_week            FixedString(1)                       ,
    d_current_month           FixedString(1)                       ,
    d_current_quarter         FixedString(1)                       ,
    d_current_year            FixedString(1)                       
) ENGINE=MergeTree()
  Partition By toYYYYMM(d_date)
  ORDER By (d_date_sk)
  SETTINGS index_granularity = 8192;

create table warehouse
(
    w_warehouse_sk            Int64              ,
    w_warehouse_id            FixedString(16)             ,
    w_warehouse_name          String                   ,
    w_warehouse_sq_ft         Int64                       ,
    w_street_number           FixedString(10)                      ,
    w_street_name             String                   ,
    w_street_type             FixedString(15)                      ,
    w_suite_number            FixedString(10)                      ,
    w_city                    String                   ,
    w_county                  String                   ,
    w_state                   FixedString(2)                       ,
    w_zip                     FixedString(10)                      ,
    w_country                 String                   ,
    w_gmt_offset              Float64                  
) ENGINE=MergeTree()
  ORDER By (w_warehouse_sk)
  SETTINGS index_granularity = 8192;

create table ship_mode
(
    sm_ship_mode_sk           Int64              ,
    sm_ship_mode_id           FixedString(16)             ,
    sm_type                   FixedString(30)                      ,
    sm_code                   FixedString(10)                      ,
    sm_carrier                FixedString(20)                      ,
    sm_contract               FixedString(20)                      
) ENGINE=MergeTree()
  ORDER By (sm_ship_mode_sk)
  SETTINGS index_granularity = 8192;

create table time_dim
(
    t_time_sk                 Int64              ,
    t_time_id                 FixedString(16)             ,
    t_time                    Int64                       ,
    t_hour                    Int64                       ,
    t_minute                  Int64                       ,
    t_second                  Int64                       ,
    t_am_pm                   FixedString(2)                       ,
    t_shift                   FixedString(20)                      ,
    t_sub_shift               FixedString(20)                      ,
    t_meal_time               FixedString(20)                      
) ENGINE=MergeTree()
  ORDER By (t_time_sk)
  SETTINGS index_granularity = 8192;

create table reason
(
    r_reason_sk               Int64              ,
    r_reason_id               FixedString(16)             ,
    r_reason_desc             FixedString(100)                     
) ENGINE=MergeTree()
  ORDER By (r_reason_sk)
  SETTINGS index_granularity = 8192;

create table income_band
(
    ib_income_band_sk         Int64              ,
    ib_lower_bound            Int64                       ,
    ib_upper_bound            Int64                       
) ENGINE=MergeTree()
  ORDER By (ib_income_band_sk)
  SETTINGS index_granularity = 8192;

create table item
(
    i_item_sk                 Int64              ,
    i_item_id                 FixedString(16)             ,
    i_rec_start_date          Date                          ,
    i_rec_end_date            Date                          ,
    i_item_desc               String                  ,
    i_current_price           Float64                  ,
    i_wholesale_cost          Float64                  ,
    i_brand_id                Int64                       ,
    i_brand                   FixedString(50)                      ,
    i_class_id                Int64                       ,
    i_class                   FixedString(50)                      ,
    i_category_id             Int64                       ,
    i_category                FixedString(50)                      ,
    i_manufact_id             Int64                       ,
    i_manufact                FixedString(50)                      ,
    i_size                    FixedString(20)                      ,
    i_formulation             FixedString(20)                      ,
    i_color                   FixedString(20)                      ,
    i_units                   FixedString(10)                      ,
    i_container               FixedString(10)                      ,
    i_manager_id              Int64                       ,
    i_product_name            FixedString(50)                      
) ENGINE=MergeTree()
  Partition By toYYYYMM(i_rec_start_date)
  ORDER By (i_item_sk)
  SETTINGS index_granularity = 8192;

create table store
(
    s_store_sk                Int64              ,
    s_store_id                FixedString(16)             ,
    s_rec_start_date          Date                          ,
    s_rec_end_date            Date                          ,
    s_closed_date_sk          Int64                       ,
    s_store_name              String                   ,
    s_number_employees        Int64                       ,
    s_floor_space             Int64                       ,
    s_hours                   FixedString(20)                      ,
    s_manager                 String                   ,
    s_market_id               Int64                       ,
    s_geography_class         String                  ,
    s_market_desc             String                  ,
    s_market_manager          String                   ,
    s_division_id             Int64                       ,
    s_division_name           String                   ,
    s_company_id              Int64                       ,
    s_company_name            String                   ,
    s_street_number           String                   ,
    s_street_name             String                   ,
    s_street_type             FixedString(15)                      ,
    s_suite_number            FixedString(10)                      ,
    s_city                    String                   ,
    s_county                  String                   ,
    s_state                   FixedString(2)                       ,
    s_zip                     FixedString(10)                      ,
    s_country                 String                   ,
    s_gmt_offset              Float64                  ,
    s_tax_precentage          Float64                  
) ENGINE=MergeTree()
  Partition By toYYYYMM(s_rec_start_date)
  ORDER By (s_store_sk)
  SETTINGS index_granularity = 8192;

create table call_center
(
    cc_call_center_sk         Int64              ,
    cc_call_center_id         FixedString(16)             ,
    cc_rec_start_date         Date                          ,
    cc_rec_end_date           Date                          ,
    cc_closed_date_sk         Int64                       ,
    cc_open_date_sk           Int64                       ,
    cc_name                   String                   ,
    cc_class                  String                   ,
    cc_employees              Int64                       ,
    cc_sq_ft                  Int64                       ,
    cc_hours                  FixedString(20)                      ,
    cc_manager                String                   ,
    cc_mkt_id                 Int64                       ,
    cc_mkt_class              FixedString(50)                      ,
    cc_mkt_desc               String                  ,
    cc_market_manager         String                   ,
    cc_division               Int64                       ,
    cc_division_name          String                   ,
    cc_company                Int64                       ,
    cc_company_name           FixedString(50)                      ,
    cc_street_number          FixedString(10)                      ,
    cc_street_name            String                   ,
    cc_street_type            FixedString(15)                      ,
    cc_suite_number           FixedString(10)                      ,
    cc_city                   String                   ,
    cc_county                 String                   ,
    cc_state                  FixedString(2)                       ,
    cc_zip                    FixedString(10)                      ,
    cc_country                String                   ,
    cc_gmt_offset             Float64                  ,
    cc_tax_percentage         Float64                  
) ENGINE=MergeTree()
  Partition By toYYYYMM(cc_rec_start_date)
  ORDER By (cc_call_center_sk)
  SETTINGS index_granularity = 8192;

create table customer
(
    c_customer_sk             Int64              ,
    c_customer_id             FixedString(16)             ,
    c_current_cdemo_sk        Int64                       ,
    c_current_hdemo_sk        Int64                       ,
    c_current_addr_sk         Int64                       ,
    c_first_shipto_date_sk    Int64                       ,
    c_first_sales_date_sk     Int64                       ,
    c_salutation              FixedString(10)                      ,
    c_first_name              FixedString(20)                      ,
    c_last_name               FixedString(30)                      ,
    c_preferred_cust_flag     FixedString(1)                       ,
    c_birth_day               Int64                       ,
    c_birth_month             Int64                       ,
    c_birth_year              Int64                       ,
    c_birth_country           String                   ,
    c_login                   FixedString(13)                      ,
    c_email_address           FixedString(50)                      ,
    c_last_review_date_sk     Int64                       
) ENGINE=MergeTree()
  Partition By c_birth_year
  ORDER By (c_customer_sk)
  SETTINGS index_granularity = 8192;

create table web_site
(
    web_site_sk               Int64              ,
    web_site_id               FixedString(16)             ,
    web_rec_start_date        Date                          ,
    web_rec_end_date          Date                          ,
    web_name                  String                   ,
    web_open_date_sk          Int64                       ,
    web_close_date_sk         Int64                       ,
    web_class                 String                   ,
    web_manager               String                   ,
    web_mkt_id                Int64                       ,
    web_mkt_class             String                   ,
    web_mkt_desc              String                  ,
    web_market_manager        String                   ,
    web_company_id            Int64                       ,
    web_company_name          FixedString(50)                      ,
    web_street_number         FixedString(10)                      ,
    web_street_name           String                   ,
    web_street_type           FixedString(15)                      ,
    web_suite_number          FixedString(10)                      ,
    web_city                  String                   ,
    web_county                String                   ,
    web_state                 FixedString(2)                       ,
    web_zip                   FixedString(10)                      ,
    web_country               String                   ,
    web_gmt_offset            Float64                  ,
    web_tax_percentage        Float64                  
) ENGINE=MergeTree()
  Partition By toYYYYMM(web_rec_start_date)
  ORDER By (web_site_sk)
  SETTINGS index_granularity = 8192;

create table store_returns
(
    sr_returned_date_sk       Int64                       ,
    sr_return_time_sk         Int64                       ,
    sr_item_sk                Int64              ,
    sr_customer_sk            Int64                       ,
    sr_cdemo_sk               Int64                       ,
    sr_hdemo_sk               Int64                       ,
    sr_addr_sk                Int64                       ,
    sr_store_sk               Int64                       ,
    sr_reason_sk              Int64                       ,
    sr_ticket_number          Int64              ,
    sr_return_quantity        Int64                       ,
    sr_return_amt             Float64                  ,
    sr_return_tax             Float64                  ,
    sr_return_amt_inc_tax     Float64                  ,
    sr_fee                    Float64                  ,
    sr_return_ship_cost       Float64                  ,
    sr_refunded_cash          Float64                  ,
    sr_reversed_charge        Float64                  ,
    sr_store_credit           Float64                  ,
    sr_net_loss               Float64                  
) ENGINE=MergeTree()
  ORDER By (sr_item_sk, sr_ticket_number)
  SETTINGS index_granularity = 8192;

create table household_demographics
(
    hd_demo_sk                Int64              ,
    hd_income_band_sk         Int64                       ,
    hd_buy_potential          FixedString(15)                      ,
    hd_dep_count              Int64                       ,
    hd_vehicle_count          Int64                       
) ENGINE=MergeTree()
  ORDER By (hd_demo_sk)
  SETTINGS index_granularity = 8192;

create table web_page
(
    wp_web_page_sk            Int64              ,
    wp_web_page_id            FixedString(16)             ,
    wp_rec_start_date         Date                          ,
    wp_rec_end_date           Date                          ,
    wp_creation_date_sk       Int64                       ,
    wp_access_date_sk         Int64                       ,
    wp_autogen_flag           FixedString(1)                       ,
    wp_customer_sk            Int64                       ,
    wp_url                    String                  ,
    wp_type                   FixedString(50)                      ,
    wp_char_count             Int64                       ,
    wp_link_count             Int64                       ,
    wp_image_count            Int64                       ,
    wp_max_ad_count           Int64                       
) ENGINE=MergeTree()
  Partition By toYYYYMM(wp_rec_start_date)
  ORDER By (wp_web_page_sk)
  SETTINGS index_granularity = 8192;

create table promotion
(
    p_promo_sk                Int64              ,
    p_promo_id                FixedString(16)             ,
    p_start_date_sk           Int64                       ,
    p_end_date_sk             Int64                       ,
    p_item_sk                 Int64                       ,
    p_cost                    Float64                 ,
    p_response_target         Int64                       ,
    p_promo_name              FixedString(50)                      ,
    p_channel_dmail           FixedString(1)                       ,
    p_channel_email           FixedString(1)                       ,
    p_channel_catalog         FixedString(1)                       ,
    p_channel_tv              FixedString(1)                       ,
    p_channel_radio           FixedString(1)                       ,
    p_channel_press           FixedString(1)                       ,
    p_channel_event           FixedString(1)                       ,
    p_channel_demo            FixedString(1)                       ,
    p_channel_details         String                  ,
    p_purpose                 FixedString(15)                      ,
    p_discount_active         FixedString(1)                       
) ENGINE=MergeTree()
  ORDER By (p_promo_sk)
  SETTINGS index_granularity = 8192;

create table catalog_page
(
    cp_catalog_page_sk        Int64              ,
    cp_catalog_page_id        FixedString(16)             ,
    cp_start_date_sk          Int64                       ,
    cp_end_date_sk            Int64                       ,
    cp_department             String                   ,
    cp_catalog_number         Int64                       ,
    cp_catalog_page_number    Int64                       ,
    cp_description            String                  ,
    cp_type                   String                  
) ENGINE=MergeTree()
  ORDER By (cp_catalog_page_sk)
  SETTINGS index_granularity = 8192;

create table inventory
(
    inv_date_sk               Int64              ,
    inv_item_sk               Int64              ,
    inv_warehouse_sk          Int64              ,
    inv_quantity_on_hand      Int64                       
) ENGINE=MergeTree()
  ORDER By (inv_date_sk, inv_item_sk, inv_warehouse_sk)
  SETTINGS index_granularity = 8192;

create table catalog_returns
(
    cr_returned_date_sk       Int64                       ,
    cr_returned_time_sk       Int64                       ,
    cr_item_sk                Int64              ,
    cr_refunded_customer_sk   Int64                       ,
    cr_refunded_cdemo_sk      Int64                       ,
    cr_refunded_hdemo_sk      Int64                       ,
    cr_refunded_addr_sk       Int64                       ,
    cr_returning_customer_sk  Int64                       ,
    cr_returning_cdemo_sk     Int64                       ,
    cr_returning_hdemo_sk     Int64                       ,
    cr_returning_addr_sk      Int64                       ,
    cr_call_center_sk         Int64                       ,
    cr_catalog_page_sk        Int64                       ,
    cr_ship_mode_sk           Int64                       ,
    cr_warehouse_sk           Int64                       ,
    cr_reason_sk              Int64                       ,
    cr_order_number           Int64              ,
    cr_return_quantity        Int64                       ,
    cr_return_amount          Float64                  ,
    cr_return_tax             Float64                  ,
    cr_return_amt_inc_tax     Float64                  ,
    cr_fee                    Float64                  ,
    cr_return_ship_cost       Float64                  ,
    cr_refunded_cash          Float64                  ,
    cr_reversed_charge        Float64                  ,
    cr_store_credit           Float64                  ,
    cr_net_loss               Float64                  
) ENGINE=MergeTree()
  ORDER By (cr_item_sk, cr_order_number)
  SETTINGS index_granularity = 8192;

create table web_returns
(
    wr_returned_date_sk       Int64                       ,
    wr_returned_time_sk       Int64                       ,
    wr_item_sk                Int64              ,
    wr_refunded_customer_sk   Int64                       ,
    wr_refunded_cdemo_sk      Int64                       ,
    wr_refunded_hdemo_sk      Int64                       ,
    wr_refunded_addr_sk       Int64                       ,
    wr_returning_customer_sk  Int64                       ,
    wr_returning_cdemo_sk     Int64                       ,
    wr_returning_hdemo_sk     Int64                       ,
    wr_returning_addr_sk      Int64                       ,
    wr_web_page_sk            Int64                       ,
    wr_reason_sk              Int64                       ,
    wr_order_number           Int64              ,
    wr_return_quantity        Int64                       ,
    wr_return_amt             Float64                  ,
    wr_return_tax             Float64                  ,
    wr_return_amt_inc_tax     Float64                  ,
    wr_fee                    Float64                  ,
    wr_return_ship_cost       Float64                  ,
    wr_refunded_cash          Float64                  ,
    wr_reversed_charge        Float64                  ,
    wr_account_credit         Float64                  ,
    wr_net_loss               Float64                  
) ENGINE=MergeTree()
  ORDER By (wr_item_sk, wr_order_number)
  SETTINGS index_granularity = 8192;

create table web_sales
(
    ws_sold_date_sk           Int64                       ,
    ws_sold_time_sk           Int64                       ,
    ws_ship_date_sk           Int64                       ,
    ws_item_sk                Int64              ,
    ws_bill_customer_sk       Int64                       ,
    ws_bill_cdemo_sk          Int64                       ,
    ws_bill_hdemo_sk          Int64                       ,
    ws_bill_addr_sk           Int64                       ,
    ws_ship_customer_sk       Int64                       ,
    ws_ship_cdemo_sk          Int64                       ,
    ws_ship_hdemo_sk          Int64                       ,
    ws_ship_addr_sk           Int64                       ,
    ws_web_page_sk            Int64                       ,
    ws_web_site_sk            Int64                       ,
    ws_ship_mode_sk           Int64                       ,
    ws_warehouse_sk           Int64                       ,
    ws_promo_sk               Int64                       ,
    ws_order_number           Int64              ,
    ws_quantity               Int64                       ,
    ws_wholesale_cost         Float64                  ,
    ws_list_price             Float64                  ,
    ws_sales_price            Float64                  ,
    ws_ext_discount_amt       Float64                  ,
    ws_ext_sales_price        Float64                  ,
    ws_ext_wholesale_cost     Float64                  ,
    ws_ext_list_price         Float64                  ,
    ws_ext_tax                Float64                  ,
    ws_coupon_amt             Float64                  ,
    ws_ext_ship_cost          Float64                  ,
    ws_net_paid               Float64                  ,
    ws_net_paid_inc_tax       Float64                  ,
    ws_net_paid_inc_ship      Float64                  ,
    ws_net_paid_inc_ship_tax  Float64                  ,
    ws_net_profit             Float64                  
) ENGINE=MergeTree()
  ORDER By (ws_item_sk, ws_order_number)
  SETTINGS index_granularity = 8192;

create table catalog_sales
(
    cs_sold_date_sk           Int64                       ,
    cs_sold_time_sk           Int64                       ,
    cs_ship_date_sk           Int64                       ,
    cs_bill_customer_sk       Int64                       ,
    cs_bill_cdemo_sk          Int64                       ,
    cs_bill_hdemo_sk          Int64                       ,
    cs_bill_addr_sk           Int64                       ,
    cs_ship_customer_sk       Int64                       ,
    cs_ship_cdemo_sk          Int64                       ,
    cs_ship_hdemo_sk          Int64                       ,
    cs_ship_addr_sk           Int64                       ,
    cs_call_center_sk         Int64                       ,
    cs_catalog_page_sk        Int64                       ,
    cs_ship_mode_sk           Int64                       ,
    cs_warehouse_sk           Int64                       ,
    cs_item_sk                Int64              ,
    cs_promo_sk               Int64                       ,
    cs_order_number           Int64              ,
    cs_quantity               Int64                       ,
    cs_wholesale_cost         Float64                  ,
    cs_list_price             Float64                  ,
    cs_sales_price            Float64                  ,
    cs_ext_discount_amt       Float64                  ,
    cs_ext_sales_price        Float64                  ,
    cs_ext_wholesale_cost     Float64                  ,
    cs_ext_list_price         Float64                  ,
    cs_ext_tax                Float64                  ,
    cs_coupon_amt             Float64                  ,
    cs_ext_ship_cost          Float64                  ,
    cs_net_paid               Float64                  ,
    cs_net_paid_inc_tax       Float64                  ,
    cs_net_paid_inc_ship      Float64                  ,
    cs_net_paid_inc_ship_tax  Float64                  ,
    cs_net_profit             Float64                  
) ENGINE=MergeTree()
  ORDER By (cs_item_sk, cs_order_number)
  SETTINGS index_granularity = 8192;

create table store_sales
(
    ss_sold_date_sk           Int64                       ,
    ss_sold_time_sk           Int64                       ,
    ss_item_sk                Int64              ,
    ss_customer_sk            Int64                       ,
    ss_cdemo_sk               Int64                       ,
    ss_hdemo_sk               Int64                       ,
    ss_addr_sk                Int64                       ,
    ss_store_sk               Int64                       ,
    ss_promo_sk               Int64                       ,
    ss_ticket_number          Int64              ,
    ss_quantity               Int64                       ,
    ss_wholesale_cost         Float64                  ,
    ss_list_price             Float64                  ,
    ss_sales_price            Float64                  ,
    ss_ext_discount_amt       Float64                  ,
    ss_ext_sales_price        Float64                  ,
    ss_ext_wholesale_cost     Float64                  ,
    ss_ext_list_price         Float64                  ,
    ss_ext_tax                Float64                  ,
    ss_coupon_amt             Float64                  ,
    ss_net_paid               Float64                  ,
    ss_net_paid_inc_tax       Float64                  ,
    ss_net_profit             Float64                  
) ENGINE=MergeTree()
  ORDER By (ss_item_sk, ss_ticket_number)
  SETTINGS index_granularity = 8192;
