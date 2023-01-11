class HttpApi {
  static const String host = 'http://localhost:8080';
  static const String host_image = 'http://localhost:8080/open/gridfs/';

  static const int corpId = 1;

  static const String user_login = '/open/user/login';
  static const String user_find = '/secure/user/';
  static const String user_reset_pwd = '/secure/user/changePassword';
  static const String user_findAll = '/secure/user/findAll';
  static const String user_add = '/secure/user';
  static const String user_update = '/secure/user/';

  static const String depart_findAll = '/secure/corpDepart/findAll';
  static const String depart_update = '/secure/corpDepart/';
  static const String depart_add = '/secure/corpDepart';
  static const String depart_find = '/secure/corpDepart';
  static const String depart_delete = '/secure/corpDepart/';

  static const String corp_pageQuery = '/open/corp/pageQuery';

  static const String corp_find_by_user = '/open/corp/findByUserId';
  static const String corp_update = '/open/corp/';
  static const String corp_add = '/open/corp/add';
  static const String corp_find = '/open/corp/find/';
  static const String corp_delete = '/open/corp/';

  static const String role_findAll = '/secure/corpRole/findAll';
  static const String role_update = '/secure/corpRole/';
  static const String role_add = '/secure/corpRole';
  static const String role_find = '/secure/corpRole/';
  static const String role_delete = '/secure/corpRole/';

  static const String role_menu_findAll = '/secure/corpRoleMenu/findAll';
  static const String role_menu_add_all = '/secure/corpRoleMenu/addAll';

  static const String user_profile_update = '/secure/user/';
  static const String open_file_upload = '/open/upload/single';
  static const String open_gridfs_upload = '/open/gridfs';

  static const String corp_manager_info_findAll =
      '/open/corpManager/findAllInfoByCorpId';
  static const String corp_manager_info_find = '/open/corpManager/findInfoById';
  static const String corp_manager_info_add = '/open/corpManager/add';
  static const String corp_manager_update = '/open/corpManager/';

  //multi part
  static const String doc_resource_upload = '/secure/docResource';

  static const String product_category_findAll = '/open/category/findAll';
  static const String product_category_update = '/secure/category/';
  static const String product_category_add = '/secure/category';
  static const String product_category_find = '/secure/category';
  static const String product_category_delete = '/open/category/';

  static const String product_query = '/open/product/findByCorpId';
  static const String product_update = '/open/product/';
  static const String product_add = '/open/product/add';
  static const String product_find = '/open/product';
  static const String product_delete = '/open/product/';
  static const String product_echo = "/open/product/findByProductId/";

  static const String product_cycle_findAll = '/secure/productCycle/findAll';
  static const String product_cylce_update = '/secure/productCycle/';
  static const String product_cylce_add = '/secure/productCycle';
  static const String product_cylce_find = '/secure/productCycle';
  static const String product_cylce_delete = '/secure/productCycle/';

  static const String product_cycle_expense_findAll =
      '/secure/productCycleExpense/findAll';
  static const String product_cylce_expense_update =
      '/secure/productCycleExpense/';
  static const String product_cylce_expense_add = '/secure/productCycleExpense';
  static const String product_cylce_expense_find =
      '/secure/productCycleExpense';
  static const String product_cylce_expense_delete =
      '/secure/productCycleExpense/';

  static const String product_risk_findAll = '/secure/productRisk/findAll';
  static const String product_risk_update = '/secure/productRisk/';
  static const String product_risk_add = '/secure/productRisk';
  static const String product_risk_find = '/secure/productRisk';
  static const String product_risk_delete = '/secure/productRisk/';

  static const String product_market_query = '/secure/productMarket/pageQuery';
  static const String product_market_findAll = '/secure/productMarket/findAll';
  static const String product_market_update = '/secure/productMarket/';
  static const String product_market_add = '/secure/productMarket';
  static const String product_market_find = '/secure/productMarket';
  static const String product_market_delete = '/secure/productMarket/';

  static const String customer_query = '/secure/customer/pageQuery';
  static const String customer_findAll = '/secure/customer/findAll';
  static const String customer_update = '/secure/customer/';
  static const String customer_add = '/secure/customer';
  static const String customer_find = '/secure/customer';
  static const String customer_delete = '/secure/customer/';

  static const String customer_link_findAll = '/secure/customerLink/findAll';
  static const String customer_link_update = '/secure/customerLink/';
  static const String customer_link_add = '/secure/customerLink';
  static const String customer_link_find = '/secure/customerLink';
  static const String customer_link_delete = '/secure/customerLink/';

  static const String customer_trace_findAll = '/secure/customerTrace/findAll';
  static const String customer_trace_query = '/secure/customerTrace/pageQuery';
  static const String customer_trace_update = '/secure/customerTrace/';
  static const String customer_trace_add = '/secure/customerTrace';
  static const String customer_trace_find = '/secure/customerTrace';
  static const String customer_trace_delete = '/secure/customerTrace/';

  static const String market_findAll = '/secure/market/findAll';
  static const String market_update = '/secure/market/';
  static const String market_add = '/secure/market';
  static const String market_find = '/secure/market';
  static const String market_delete = '/secure/market/';

  static const String contract_findAll = '/secure/contract/findAll';
  static const String contract_query = '/secure/contract/pageQuery';
  static const String contract_update = '/secure/contract/';
  static const String contract_add = '/secure/contract';
  static const String contract_find = '/secure/contract';
  static const String contract_delete = '/secure/contract/';

  static const String park_findAll = '/secure/park/findAll';
  static const String park_query = '/secure/park/pageQuery';
  static const String park_update = '/secure/park/';
  static const String park_add = '/secure/park';
  static const String park_find = '/secure/park';
  static const String park_delete = '/secure/park/';

  static const String park_base_findAll = '/secure/parkBase/findAll';
  static const String park_base_query = '/secure/parkBase/pageQuery';
  static const String park_base_update = '/secure/parkBase/';
  static const String park_base_add = '/secure/parkBase';
  static const String park_base_find = '/secure/parkBase';
  static const String park_base_delete = '/secure/parkBase/';

  static const String doc_findAll = '/secure/docResource/findAll';
  static const String doc_update = '/secure/docResource/';
  static const String doc_add = '/secure/docResource';
  static const String doc_find = '/secure/docResource';
  static const String doc_delete = '/secure/docResource/';

  static const String batch_findAll = '/secure/productBatch/findAll';
  static const String batch_query = '/secure/productBatch/pageQuery';
  static const String batch_update = '/secure/productBatch/';
  static const String batch_add = '/secure/productBatch';
  static const String batch_find = '/secure/productBatch';
  static const String batch_delete = '/secure/productBatch/';

  static const String batch_cycle_findAll = '/secure/batchCycle/findAll';
  static const String batch_cycle_findAll_parent =
      '/secure/batchCycle/findAllByParent';
  static const String batch_cycle_query = '/secure/batchCycle/pageQuery';
  static const String batch_cycle_update = '/secure/batchCycle/';
  static const String batch_cycle_add = '/secure/batchCycle';
  static const String batch_cycle_find = '/secure/batchCycle';
  static const String batch_cycle_delete = '/secure/batchCycle/';

  static const String batch_risk_findAll = '/secure/batchRisk/findAll';
  static const String batch_risk_query = '/secure/batchRisk/pageQuery';
  static const String batch_risk_update = '/secure/batchRisk/';
  static const String batch_risk_add = '/secure/batchRisk';
  static const String batch_risk_find = '/secure/batchRisk';
  static const String batch_risk_delete = '/secure/batchRisk/';

  static const String batch_cycle_execute_findAll =
      '/secure/batchCycleExecute/findAll';
  static const String batch_cycle_execute_query =
      '/secure/batchCycleExecute/pageQuery';
  static const String batch_cycle_execute_update = '/secure/batchCycleExecute/';
  static const String batch_cycle_execute_add = '/secure/batchCycleExecute';
  static const String batch_cycle_execute_find = '/secure/batchCycleExecute';
  static const String batch_cycle_execute_delete = '/secure/batchCycleExecute/';

  static const String batch_cycle_expense_findAll =
      '/secure/batchCycleExpense/findAll';
  static const String batch_cycle_expense_query =
      '/secure/batchCycleExpense/pageQuery';
  static const String batch_cycle_expense_update = '/secure/batchCycleExpense/';
  static const String batch_cycle_expense_add = '/secure/batchCycleExpense';
  static const String batch_cycle_expense_find = '/secure/batchCycleExpense';
  static const String batch_cycle_expense_delete = '/secure/batchCycleExpense/';

  static const String batch_team_findAll = '/secure/batchTeam/findAll';
  static const String batch_team_query = '/secure/batchTeam/pageQuery';
  static const String batch_team_update = '/secure/batchTeam/';
  static const String batch_team_add = '/secure/batchTeam';
  static const String batch_team_find = '/secure/batchTeam';
  static const String batch_team_delete = '/secure/batchTeam/';

  static const String sys_menu_findAll = '/secure/sysMenu/findAll';
  static const String sys_menu_findAllSub = '/secure/sysMenu/findAllSub';
  static const String sys_menu_update = '/secure/sysMenu/';
  static const String sys_menu_add = '/secure/sysMenu';
  static const String sys_menu_find = '/secure/sysMenu/';
  static const String sys_menu_delete = '/secure/sysMenu/';
}
