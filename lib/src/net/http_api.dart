class HttpApi {
  static const String host = 'https://api.gucuntech.cn';
  static const String host_image = 'https://api.gucuntech.cn/open/gridfs/';
  //static const String host = 'http://localhost:8080';
  //static const String host_image = 'http://localhost:8080/open/gridfs/';

  static const String user_login = '/open/user/login';
  static const String user_login_mobile = '/open/user/loginByMobile';
  static const String user_find = '/secure/user/';
  static const String user_reset_pwd = '/secure/user/changePassword';
  static const String user_findAll = '/secure/user/findAll';
  static const String user_add = '/secure/user';
  static const String user_update = '/secure/user/';

  static const String depart_findAll = '/secure/corpDepart/findAllByCorpId';
  static const String depart_update = '/secure/corpDepart/';
  static const String depart_add = '/secure/corpDepart';
  static const String depart_find = '/secure/corpDepart';
  static const String depart_delete = '/secure/corpDepart/';

  static const String corp_pageQuery = '/secure/corp/pageQuery';

  static const String corp_find_by_user = '/secure/corp/findByUserId';
  static const String corp_update = '/secure/corp/';
  static const String corp_add = '/secure/corp';
  static const String corp_find = '/secure/corp/find/';
  static const String corp_delete = '/secure/corp/';

  static const String role_findAll = '/secure/corpRole/findAllByCorpId';
  static const String role_update = '/secure/corpRole/';
  static const String role_add = '/secure/corpRole';
  static const String role_find = '/secure/corpRole/';
  static const String role_delete = '/secure/corpRole/';

  static const String role_menu_findAll = '/secure/corpRoleMenu/findAll';
  static const String role_menu_add_all = '/secure/corpRoleMenu/addAll';

  static const String user_profile_update = '/secure/user/';
  //static const String open_file_upload = '/open/upload/single';
  static const String open_gridfs_upload = '/open/gridfs';

  static const String corp_manager_info_findAll =
      '/secure/corpManager/findAllInfoByCorpId';
  static const String corp_manager_info_find = '/secure/corpManager/findInfoById';
  static const String corp_manager_info_add = '/secure/corpManager';
  static const String corp_manager_update = '/secure/corpManager/';

  static const String corp_manager_exists_mobile = '/secure/corpManager/existMobile';

  //multi part
  static const String doc_resource_upload = '/secure/docResource/upload';

  static const String cms_blog_query = '/secure/cmsBlog/pageQuery';
  static const String cms_blog_update = '/secure/cmsBlog/';
  static const String cms_blog_add = '/secure/cmsBlog';
  static const String cms_blog_find = '/secure/cmsBlog/';
  static const String cms_blog_delete = '/secure/cmsBlog/';

  static const String cms_user_active_query = '/secure/cmsUserActive/pageQuery';
  static const String cms_user_active_update = '/secure/cmsUserActive/';
  static const String cms_user_active_add = '/secure/cmsUserActive';
  static const String cms_user_active_find = '/secure/cmsUserActive/';
  static const String cms_user_active_delete = '/secure/cmsUserActive/';


  static const String cms_category_findAll = '/secure/cmsCategory/findAllByCorpId';
  static const String cms_category_update = '/secure/cmsCategory/';
  static const String cms_category_add = '/secure/cmsCategory';
  static const String cms_category_find = '/secure/cmsCategory/';
  static const String cms_category_delete = '/secure/cmsCategory/';


  static const String product_category_findAll = '/secure/category/findAll';
  static const String product_category_update = '/secure/category/';
  static const String product_category_add = '/secure/category';
  static const String product_category_find = '/secure/category/';
  static const String product_category_delete = '/secure/category/';

  static const String product_query = '/secure/product/pageQuery';
  static const String product_update = '/secure/product/';
  static const String product_add = '/secure/product';
  static const String product_find = '/secure/product/';
  static const String product_delete = '/secure/product/';


  static const String product_cycle_findAll = '/secure/productCycle/findAll';
  static const String product_cylce_update = '/secure/productCycle/';
  static const String product_cylce_add = '/secure/productCycle';
  static const String product_cylce_find = '/secure/productCycle/';
  static const String product_cylce_delete = '/secure/productCycle/';

  static const String product_cycle_expense_findAll =
      '/secure/productCycleExpense/findAll';
  static const String product_cylce_expense_update =
      '/secure/productCycleExpense/';
  static const String product_cylce_expense_add = '/secure/productCycleExpense';
  static const String product_cylce_expense_find =
      '/secure/productCycleExpense/';
  static const String product_cylce_expense_delete =
      '/secure/productCycleExpense/';

  static const String product_risk_findAll = '/secure/productRisk/findAll';
  static const String product_risk_update = '/secure/productRisk/';
  static const String product_risk_add = '/secure/productRisk';
  static const String product_risk_find = '/secure/productRisk/';
  static const String product_risk_delete = '/secure/productRisk/';

  static const String product_market_query = '/secure/mark/productMarket/pageQuery';
  static const String product_market_findAll = '/secure/mark/productMarket/findAll';
  static const String product_market_update = '/secure/mark/productMarket/';
  static const String product_market_add = '/secure/mark/productMarket';
  static const String product_market_find = '/secure/mark/productMarket/';
  static const String product_market_delete = '/secure/mark/productMarket/';

  static const String customer_query = '/secure/customer/pageQuery';
  static const String customer_update = '/secure/customer/';
  static const String customer_add = '/secure/customer';
  static const String customer_find = '/secure/customer/';
  static const String customer_delete = '/secure/customer/';

  static const String customer_link_findAll = '/secure/customerLink/findAllByCustomerId';
  static const String customer_link_update = '/secure/customerLink/';
  static const String customer_link_add = '/secure/customerLink';
  static const String customer_link_find = '/secure/customerLink/';
  static const String customer_link_delete = '/secure/customerLink/';

  static const String customer_trace_findAll = '/secure/customerTrace/findAllByCustomerId';
  static const String customer_trace_query = '/secure/customerTrace/pageQuery';
  static const String customer_trace_update = '/secure/customerTrace/';
  static const String customer_trace_add = '/secure/customerTrace';
  static const String customer_trace_find = '/secure/customerTrace/';
  static const String customer_trace_delete = '/secure/customerTrace/';

  static const String market_query = '/secure/mark/market/pageQuery';
  static const String market_update = '/secure/mark/market/';
  static const String market_add = '/secure/mark/market';
  static const String market_find = '/secure/mark/market/';
  static const String market_delete = '/secure/mark/market/';

  static const String mark_category_query = '/secure/mark/category/pageQuery';
  static const String mark_category_update = '/secure/mark/category/';
  static const String mark_category_add = '/secure/mark/category';
  static const String mark_category_find = '/secure/mark/category/';
  static const String mark_category_delete = '/secure/mark/category/';

  static const String mark_product_query = '/secure/mark/product/pageQuery';
  static const String mark_product_update = '/secure/mark/product/';
  static const String mark_product_add = '/secure/mark/product';
  static const String mark_product_find = '/secure/mark/product/';
  static const String mark_product_delete = '/secure/mark/product/';

  static const String mark_product_market_query = '/secure/mark/productMarket/pageQuery';
  static const String mark_product_market_update = '/secure/mark/productMarket/';
  static const String mark_product_market_add = '/secure/mark/productMarket';
  static const String mark_product_market_find = '/secure/mark/productMarket/';
  static const String mark_product_market_delete = '/secure/mark/productMarket/';

  static const String address_updte = '/secure/address/';
  static const String address_add = '/secure/address';
  static const String address_find = '/secure/address/';
  static const String address_delete = '/secure/address/';

  static const String contract_findAll = '/secure/customerContract/findAllByCustomerId';
  static const String contract_query = '/secure/customerContract/pageQuery';
  static const String contract_update = '/secure/customerContract/';
  static const String contract_add = '/secure/customerContract';
  static const String contract_find = '/secure/customerContract/';
  static const String contract_delete = '/secure/customerContract/';

  static const String park_findAll = '/secure/corpPark/findAllByCorpId';
  static const String park_query = '/secure/corpPark/pageQuery';
  static const String park_update = '/secure/corpPark/';
  static const String park_add = '/secure/corpPark';
  static const String park_find = '/secure/corpPark/';
  static const String park_delete = '/secure/corpPark/';

  static const String park_base_findAll = '/secure/corpParkBase/findAllByParkId';
  static const String park_base_query = '/secure/corpParkBase/pageQuery';
  static const String park_base_update = '/secure/corpParkBase/';
  static const String park_base_add = '/secure/corpParkBase';
  static const String park_base_find = '/secure/corpParkBase/';
  static const String park_base_delete = '/secure/corpParkBase/';

  static const String doc_page_query = '/secure/docResource/pageQuery';
  static const String doc_update = '/secure/docResource/';
  static const String doc_add = '/secure/docResource';
  static const String doc_find = '/secure/docResource/';
  static const String doc_delete = '/secure/docResource/';

  static const String batch_findAll = '/secure/batchProduct/findAll';
  static const String batch_query = '/secure/batchProduct/pageQuery';
  static const String batch_update = '/secure/batchProduct/';
  static const String batch_add = '/secure/batchProduct';
  static const String batch_find = '/secure/batchProduct/';
  static const String batch_delete = '/secure/batchProduct/';
  static const String batch_analysis = '/secure/batchProduct/analysis/';

  static const String batch_cycle_findAll = '/secure/batchCycle/findAllByBatchId';
  static const String batch_cycle_findAll_parent =
      '/secure/batchCycle/findAllByParentId';
  static const String batch_cycle_query = '/secure/batchCycle/pageQuery';
  static const String batch_cycle_update = '/secure/batchCycle/';
  static const String batch_cycle_add = '/secure/batchCycle';
  static const String batch_cycle_find = '/secure/batchCycle/';
  static const String batch_cycle_delete = '/secure/batchCycle/';

  static const String batch_risk_findAll = '/secure/batchRisk/findAllByBatchId';
  static const String batch_risk_query = '/secure/batchRisk/pageQuery';
  static const String batch_risk_update = '/secure/batchRisk/';
  static const String batch_risk_add = '/secure/batchRisk';
  static const String batch_risk_find = '/secure/batchRisk/';
  static const String batch_risk_delete = '/secure/batchRisk/';

  static const String batch_base_query = '/secure/batchBase/pageQuery';
  static const String batch_base_update = '/secure/batchBase/';
  static const String batch_base_add = '/secure/batchBase';
  static const String batch_base_find = '/secure/batchBase/';
  static const String batch_base_delete = '/secure/batchBase/';

  static const String batch_cycle_invest_query = '/secure/batchCycleInvest/pageQuery';
  static const String batch_cycle_invest_findAllByBatchCycleId = '/secure/batchCycleInvest/findAllByBatchCycleId';
  static const String batch_cycle_invest_update = '/secure/batchCycleInvest/';
  static const String batch_cycle_invest_add = '/secure/batchCycleInvest';
  static const String batch_cycle_invest_find = '/secure/batchCycleInvest/';
  static const String batch_cycle_invest_delete = '/secure/batchCycleInvest/';

  static const String batch_cycle_execute_findAll =
      '/secure/batchCycleExecute/findAllByCycleId';
  static const String batch_cycle_execute_query =
      '/secure/batchCycleExecute/pageQuery';
  static const String batch_cycle_execute_update = '/secure/batchCycleExecute/';
  static const String batch_cycle_execute_add = '/secure/batchCycleExecute';
  static const String batch_cycle_execute_find = '/secure/batchCycleExecute/';
  static const String batch_cycle_execute_delete = '/secure/batchCycleExecute/';

  static const String finance_expense_findAll =
      '/secure/financeExpense/findAllByBatchId';
  static const String finance_expense_query =
      '/secure/financeExpense/pageQuery';
  static const String finance_expense_update = '/secure/financeExpense/';
  static const String finance_expense_add = '/secure/financeExpense';
  static const String finance_expense_find = '/secure/financeExpense/';
  static const String finance_expense_delete = '/secure/financeExpense/';

  static const String finance_expense_item_findAll =
      '/secure/financeExpenseItem/findAllByExpenseId';
  static const String finance_expense_item_query =
      '/secure/financeExpenseItem/pageQuery';
  static const String finance_expense_item_update = '/secure/financeExpenseItem/';
  static const String finance_expense_item_add = '/secure/financeExpenseItem';
  static const String finance_expense_item_find = '/secure/financeExpenseItem/';
  static const String finance_expense_item_delete = '/secure/financeExpenseItem/';

  static const String sale_order_findAll =
      '/secure/saleOrder/findAllByBatchId';
  static const String sale_order_query =
      '/secure/saleOrder/pageQuery';
  static const String sale_order_update = '/secure/saleOrder/';
  static const String sale_order_add = '/secure/saleOrder';
  static const String sale_order_find = '/secure/saleOrder/';
  static const String sale_order_delete = '/secure/saleOrder/';

  static const String sale_order_item_findAll =
      '/secure/saleOrderItem/findAllByOrderId';
  static const String sale_order_item_query =
      '/secure/saleOrderItem/pageQuery';
  static const String sale_order_item_update = '/secure/saleOrderItem/';
  static const String sale_order_item_add = '/secure/saleOrderItem';
  static const String sale_order_item_find = '/secure/saleOrderItem/';
  static const String sale_order_item_delete = '/secure/saleOrderItem/';

  static const String purchase_order_findAll =
      '/secure/purchaseOrder/findAllByBatchId';
  static const String purchase_order_query =
      '/secure/purchaseOrder/pageQuery';
  static const String purchase_order_update = '/secure/purchaseOrder/';
  static const String purchase_order_add = '/secure/purchaseOrder';
  static const String purchase_order_find = '/secure/purchaseOrder/';
  static const String purchase_order_delete = '/secure/purchaseOrder/';

  static const String purchase_order_item_findAll =
      '/secure/purchaseOrderItem/findAllByOrderId';
  static const String purchase_order_item_query =
      '/secure/purchaseOrderItem/pageQuery';
  static const String purchase_order_item_update = '/secure/purchaseOrderItem/';
  static const String purchase_order_item_add = '/secure/purchaseOrderItem';
  static const String purchase_order_item_find = '/secure/purchaseOrderItem/';
  static const String purchase_order_item_delete = '/secure/purchaseOrderItem/';


  static const String check_apply_query =
      '/secure/checkApply/pageQuery';
  static const String check_apply_update = '/secure/checkApply/';
  static const String check_apply_add = '/secure/checkApply';
  static const String check_apply_find = '/secure/checkApply/';
  static const String check_apply_delete = '/secure/checkApply/';

  static const String check_trace_query =
      '/secure/checkTrace/pageQuery';
  static const String check_trace_update = '/secure/checkTrace/';
  static const String check_trace_add = '/secure/checkTrace';
  static const String check_trace_find = '/secure/checkTrace/';
  static const String check_trace_update_status = '/secure/checkTrace/updateStatus';
  static const String check_trace_delete = '/secure/checkTrace/';



  static const String batch_team_findAll = '/secure/batchTeam/findAllByBatchId';
  static const String batch_team_update = '/secure/batchTeam/';
  static const String batch_team_add = '/secure/batchTeam';
  static const String batch_team_find = '/secure/batchTeam/';
  static const String batch_team_delete = '/secure/batchTeam/';

  static const String sys_menu_findAll = '/secure/sysMenu/findAll';
  static const String sys_menu_findAllSub = '/secure/sysMenu/findAllSub';
  static const String sys_menu_update = '/secure/sysMenu/';
  static const String sys_menu_add = '/secure/sysMenu';
  static const String sys_menu_find = '/secure/sysMenu/';
  static const String sys_menu_delete = '/secure/sysMenu/';
}
