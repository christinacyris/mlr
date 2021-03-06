context("classif_nodeHarvest")

test_that("classif_nodeHarvest", {
  requirePackages("nodeHarvest")
  
  parset.list = list(
    list(nodes = 100L),
    list(nodes = 100L, maxinter = 1L),
    list(nodes = 100L, mode = "outbag")
  )

  old.predicts.list = list()
  old.probs.list = list()
  
  for (i in 1:length(parset.list)) {
    parset = parset.list[[i]]
    Y = ifelse(binaryclass.df[binaryclass.train.inds, binaryclass.class.col] == binaryclass.class.levs[1], 1, 0)
    parset = c(parset, list(X = binaryclass.df[binaryclass.train.inds, -binaryclass.class.col], Y = Y, silent = TRUE))
    set.seed(getOption("mlr.debug.seed"))
    m = do.call(nodeHarvest::nodeHarvest, parset)
    p = predict(m, binaryclass.df[-binaryclass.train.inds,])
    old.predicts.list[[i]] = ifelse(p > 0.5, binaryclass.class.levs[1], binaryclass.class.levs[2])
    old.probs.list[[i]] = p
  }
  
  testSimpleParsets("classif.nodeHarvest", binaryclass.df, binaryclass.target, binaryclass.train.inds,
    old.predicts.list, parset.list)
  testProbParsets ("classif.nodeHarvest", binaryclass.df, binaryclass.target,
                   binaryclass.train.inds, old.probs.list, parset.list)
})
