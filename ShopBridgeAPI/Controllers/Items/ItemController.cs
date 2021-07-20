using Business.Items;
using Entities.Common.Audit;
using Entities.Common.Response;
using Entities.Inventory;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using ShopBridgeAPI.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using System.Transactions;

namespace ShopBridgeAPI.Controllers.Items
{
    [ApiController]
    public class ItemController : ControllerBase
    {
        private readonly ILogger<ItemController> _logger;
        private readonly IManageItem _manageItem;

        public ItemController(ILogger<ItemController> logger,
                              IManageItem manageItem)
        {
            _logger = logger;
            _manageItem = manageItem;
        }

        [HttpGet]
        [Route(ItemRoute.Item)]
        public IActionResult GetAllItem()
        {
            try
            {
                var item = _manageItem.GetItemAll();

                return new JsonResult(new SBResponse
                {
                    Response = new SBDataResponse
                    {
                        Status = 2000,
                        Data = item
                    }
                });
            }
            catch (WebException ex)
            {
                _logger.LogError(ex, ex.Message);
                return new JsonResult(new SBResponse
                {
                    Response = new SBDataResponse
                    {
                        Status = (int)HttpStatusCode.InternalServerError,
                        Message = ex.Message
                    }
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, ex.Message);
                return new JsonResult(new SBResponse
                {
                    Response = new SBDataResponse
                    {
                        Status = (int)HttpStatusCode.InternalServerError,
                        Message = ex.Message
                    }
                });
            }
        }

        [HttpGet]
        [Route(ItemRoute.ItemById)]
        public IActionResult GetItemById(long id)
        {
            try
            {
                var item = _manageItem.GetItemById(id);

                return new JsonResult(new SBResponse
                {
                    Response = new SBDataResponse
                    {
                        Status = 2000,
                        Data = item
                    }
                });
            }
            catch (WebException ex)
            {
                _logger.LogError(ex, ex.Message);
                return new JsonResult(new SBResponse
                {
                    Response = new SBDataResponse
                    {
                        Status = (int)HttpStatusCode.InternalServerError,
                        Message = ex.Message
                    }
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, ex.Message);
                return new JsonResult(new SBResponse
                {
                    Response = new SBDataResponse
                    {
                        Status = (int)HttpStatusCode.InternalServerError,
                        Message = ex.Message
                    }
                });
            }
        }

        [HttpPost]
        [Route(ItemRoute.Item)]
        public IActionResult CreateItem([FromBody] Inventory item)
        {
            using (var scope = new TransactionScope(TransactionScopeOption.RequiresNew))
            {
                try
                {
                    string createdBy = Request?.Headers["userId"];                    
                    if (string.IsNullOrEmpty(createdBy))
                    {
                        return new JsonResult(new SBResponse
                        {
                            Response = new SBDataResponse
                            {
                                Status = ErrorMessages.Item.CreatedByNotFound.Code,
                                Message = ErrorMessages.Item.CreatedByNotFound.Message
                            }
                        });
                    }

                    if (item == null || string.IsNullOrEmpty(item.ItemName))
                    {
                        return new JsonResult(new SBResponse
                        {
                            Response = new SBDataResponse
                            {
                                Status = ErrorMessages.Item.ItemNameIsrequired.Code,
                                Message = ErrorMessages.Item.ItemNameIsrequired.Message,
                            }
                        });
                    }
                
                    item.AuditDetail = new AuditInfo()
                    {
                        CreatedBy = createdBy
                    };

                    _manageItem.CreateItem(item);

                    scope.Complete();                    
                    return new JsonResult(new SBResponse
                    {
                        Response = new SBDataResponse
                        {
                            Status = 2000,
                            Data = "Item created!"
                        }
                    });
                }
                catch (WebException ex)
                {
                    _logger.LogError(ex, ex.Message);
                    return new JsonResult(new SBResponse
                    {
                        Response = new SBDataResponse
                        {
                            Status = (int)HttpStatusCode.InternalServerError,
                            Message = ex.Message
                        }
                    });
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, ex.Message);
                    return new JsonResult(new SBResponse
                    {
                        Response = new SBDataResponse
                        {
                            Status = (int)HttpStatusCode.InternalServerError,
                            Message = ex.Message
                        }
                    });
                }
            }
        }

        [HttpPut]
        [Route(ItemRoute.ItemById)]
        public IActionResult UpdateItem(long id, [FromBody] Inventory item)
        {
            using (var scope = new TransactionScope(TransactionScopeOption.RequiresNew))
            {
                try
                {
                    string modifiedBy = Request?.Headers["userId"];
                    if (string.IsNullOrEmpty(modifiedBy))
                    {
                        return new JsonResult(new SBResponse
                        {
                            Response = new SBDataResponse
                            {
                                Status = ErrorMessages.Item.CreatedByNotFound.Code,
                                Message = ErrorMessages.Item.CreatedByNotFound.Message
                            }
                        });
                    }

                    if (id == 0) 
                    {
                        return new JsonResult(new SBResponse
                        {
                            Response = new SBDataResponse
                            {
                                Status = ErrorMessages.Item.InvalidItemId.Code,
                                Message = ErrorMessages.Item.InvalidItemId.Message
                            }
                        });
                    }

                                     

                    item.ItemId = id;                    
                    item.AuditDetail = new AuditInfo()
                    {
                        ModifiedBy = modifiedBy
                    };
                    _manageItem.UpdateItem(item);
                    scope.Complete();

                    return new JsonResult(new SBResponse
                    {
                        Response = new SBDataResponse
                        {
                            Status = 2000,
                            Data = "Item updatd!"
                        }
                    });
                }
                catch (WebException ex)
                {
                    _logger.LogError(ex, ex.Message);
                    return new JsonResult(new SBResponse
                    {
                        Response = new SBDataResponse
                        {
                            Status = (int)HttpStatusCode.InternalServerError,
                            Message = ex.Message
                        }
                    });
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, ex.Message);
                    return new JsonResult(new SBResponse
                    {
                        Response = new SBDataResponse
                        {
                            Status = (int)HttpStatusCode.InternalServerError,
                            Message = ex.Message
                        }
                    });
                }
            }
        }





        [HttpPatch]
        [Route(ItemRoute.DeleteItemById)]
        public IActionResult DeleteItem(long id, [FromBody] Inventory item)
        {
            try
            {
                string deletedBy = Request?.Headers["userId"];
                if (string.IsNullOrEmpty(deletedBy))
                {
                    return new JsonResult(new SBResponse
                    {
                        Response = new SBDataResponse
                        {
                            Status = ErrorMessages.Item.CreatedByNotFound.Code,
                            Message = ErrorMessages.Item.CreatedByNotFound.Message
                        }
                    });
                }

                if (id == 0)
                {
                    return new JsonResult(new SBResponse
                    {
                        Response = new SBDataResponse
                        {
                            Status = ErrorMessages.Item.InvalidItemId.Code,
                            Message = ErrorMessages.Item.InvalidItemId.Message
                        }
                    });
                }

                item.ItemId = id;
                item.AuditDetail = new AuditInfo()
                {
                    DeletedBy = deletedBy
                };
           

                _manageItem.DeleteItem(item);

                return new JsonResult(new SBResponse
                {
                    Response = new SBDataResponse
                    {
                        Status = 2000,
                        Data = "Item deleted!"
                    }
                });
            }
            catch (WebException ex)
            {
                _logger.LogError(ex, ex.Message);
                return new JsonResult(new SBResponse
                {
                    Response = new SBDataResponse
                    {
                        Status = (int)HttpStatusCode.InternalServerError,
                        Message = ex.Message
                    }
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, ex.Message);
                return new JsonResult(new SBResponse
                {
                    Response = new SBDataResponse
                    {
                        Status = (int)HttpStatusCode.InternalServerError,
                        Message = ex.Message
                    }
                });
            }
        }
    }
}
