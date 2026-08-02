CREATE TABLE IF NOT EXISTS app_users(
  id BIGSERIAL PRIMARY KEY,email TEXT UNIQUE NOT NULL,name TEXT NOT NULL,role TEXT NOT NULL,password_hash TEXT NOT NULL,created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS workflow_cases(
  id BIGSERIAL PRIMARY KEY,workflow_id TEXT NOT NULL,reference TEXT UNIQUE NOT NULL,subject TEXT NOT NULL,owner TEXT NOT NULL,state TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,payload JSONB NOT NULL DEFAULT '{}'::jsonb,created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS audit_events(
  id BIGSERIAL PRIMARY KEY,event_time TIMESTAMPTZ NOT NULL DEFAULT NOW(),actor TEXT NOT NULL,action TEXT NOT NULL,object_type TEXT NOT NULL,object_reference TEXT NOT NULL,detail TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS saved_analyses(
  id BIGSERIAL PRIMARY KEY,workflow_id TEXT NOT NULL,actor TEXT NOT NULL,analysis_type TEXT NOT NULL,inputs JSONB NOT NULL,result JSONB NOT NULL,provider TEXT NOT NULL,model TEXT,created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS integration_state(
  id TEXT PRIMARY KEY,name TEXT NOT NULL,category TEXT NOT NULL,mode TEXT NOT NULL,status TEXT NOT NULL,last_tested TIMESTAMPTZ
);
CREATE INDEX IF NOT EXISTS idx_workflow_cases_workflow ON workflow_cases(workflow_id);
CREATE INDEX IF NOT EXISTS idx_workflow_cases_due ON workflow_cases(due_date);
CREATE INDEX IF NOT EXISTS idx_audit_events_time ON audit_events(event_time DESC);

CREATE TABLE IF NOT EXISTS "op_ice_schedule"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_fiscalYear" NUMERIC(16,2) NOT NULL,
  "data_schedule" TEXT NOT NULL,
  "data_claimedCost" NUMERIC(16,2) NOT NULL,
  "data_reconciliationNotes" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_ice_schedule_due ON "op_ice_schedule"(due_date);

CREATE TABLE IF NOT EXISTS "op_indirect_rate"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_pool" TEXT NOT NULL,
  "data_poolCost" NUMERIC(16,2) NOT NULL,
  "data_allocationBase" NUMERIC(16,2) NOT NULL,
  "data_rateRationale" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_indirect_rate_due ON "op_indirect_rate"(due_date);

CREATE TABLE IF NOT EXISTS "op_unallowable"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_transactionId" TEXT NOT NULL,
  "data_account" TEXT NOT NULL,
  "data_amount" NUMERIC(16,2) NOT NULL,
  "data_allowabilityRationale" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_unallowable_due ON "op_unallowable"(due_date);

CREATE TABLE IF NOT EXISTS "op_contract_reconcile"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_contract" TEXT NOT NULL,
  "data_clin" TEXT NOT NULL,
  "data_recordedCost" NUMERIC(16,2) NOT NULL,
  "data_billedCost" NUMERIC(16,2) NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_contract_reconcile_due ON "op_contract_reconcile"(due_date);

CREATE TABLE IF NOT EXISTS "op_subcontract"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_subcontractor" TEXT NOT NULL,
  "data_subcontract" TEXT NOT NULL,
  "data_incurredCost" NUMERIC(16,2) NOT NULL,
  "data_supportNotes" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_subcontract_due ON "op_subcontract"(due_date);

CREATE TABLE IF NOT EXISTS "op_labor"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_employee" TEXT NOT NULL,
  "data_payPeriod" TEXT NOT NULL,
  "data_laborHours" NUMERIC(16,2) NOT NULL,
  "data_distributionNotes" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_labor_due ON "op_labor"(due_date);

CREATE TABLE IF NOT EXISTS "op_adequacy"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_fiscalYear" NUMERIC(16,2) NOT NULL,
  "data_scheduleCount" NUMERIC(16,2) NOT NULL,
  "data_exceptionCount" NUMERIC(16,2) NOT NULL,
  "data_adequacyNotes" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_adequacy_due ON "op_adequacy"(due_date);

CREATE TABLE IF NOT EXISTS "op_audit_response"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_requestId" TEXT NOT NULL,
  "data_requestDate" DATE NOT NULL,
  "data_responseDue" DATE NOT NULL,
  "data_responsePosition" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_audit_response_due ON "op_audit_response"(due_date);

CREATE TABLE IF NOT EXISTS "op_contract_master"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_contract" TEXT NOT NULL,
  "data_agency" TEXT NOT NULL,
  "data_contractType" TEXT NOT NULL,
  "data_fundedValue" NUMERIC(16,2) NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_contract_master_due ON "op_contract_master"(due_date);

CREATE TABLE IF NOT EXISTS "op_pool_base_master"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_pool" TEXT NOT NULL,
  "data_poolType" TEXT NOT NULL,
  "data_allocationBase" TEXT NOT NULL,
  "data_provisionalRate" NUMERIC(16,2) NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_pool_base_master_due ON "op_pool_base_master"(due_date);

CREATE TABLE IF NOT EXISTS "op_far_cost_library"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_costType" TEXT NOT NULL,
  "data_farCitation" TEXT NOT NULL,
  "data_allowability" TEXT NOT NULL,
  "data_documentation" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_far_cost_library_due ON "op_far_cost_library"(due_date);

CREATE TABLE IF NOT EXISTS "op_ice_schedule_master"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_schedule" TEXT NOT NULL,
  "data_purpose" TEXT NOT NULL,
  "data_preparer" TEXT NOT NULL,
  "data_crossChecks" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_ice_schedule_master_due ON "op_ice_schedule_master"(due_date);
