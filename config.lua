if string.sub(system.getInfo("model"),1,4) == "iPad" then
    application = 
    {
		license =
		{
			google =
			{
				key = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwDhhCQu2eHQ0eA2M2y7yLDmF5AMO2N1GjEBn+hSCN6guc5QS2uR8IRPlwg1CDZ/DwjYwZ6fgpCJjHRl/GVxrAmzYC7cPhdJ29i4ppSEzAi8SxBKa3IwSZlzi64lWqr5NRbrfmc0mZjrQUTcHpRpdUjn9/TJIaa41LM7xyVnPAT/krqhwIwsURmTfGJRmCzxZI8+Xr2hZgOuyDWptE7mmCS0vVMQsnPATlmgiCnJOQythiap7Qr+2s6giupWWaF/1UYGB/EudvcdDPE4DN/mEBUfCBA/WXsH5DbJI8vwuuKPwNKieNEprIvL9NR5ahfw5xYYvaC2EpLBqMgIMHotwMQIDAQAB",
			},
		},
        content =
        {           
            fps = 60,
            width = 360,
            height = 480,
            scale = "letterBox",
          --  xAlign = "center",
          --  yAlign = "center",
            imageSuffix = 
            {
                ["@2x"] = 1.5,
                ["@4x"] = 3.0,
            },
        },
        notification = 
        {
            iphone = {
                types = {
                    "badge", "sound", "alert"
                }
            },
            google =
        {
                projectNumber = "xxxx",
         },
        }
    }

elseif string.sub(system.getInfo("model"),1,2) == "iP" and display.pixelHeight > 960 then
    application = 
    {
		license =
		{
			google =
			{
				key = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwDhhCQu2eHQ0eA2M2y7yLDmF5AMO2N1GjEBn+hSCN6guc5QS2uR8IRPlwg1CDZ/DwjYwZ6fgpCJjHRl/GVxrAmzYC7cPhdJ29i4ppSEzAi8SxBKa3IwSZlzi64lWqr5NRbrfmc0mZjrQUTcHpRpdUjn9/TJIaa41LM7xyVnPAT/krqhwIwsURmTfGJRmCzxZI8+Xr2hZgOuyDWptE7mmCS0vVMQsnPATlmgiCnJOQythiap7Qr+2s6giupWWaF/1UYGB/EudvcdDPE4DN/mEBUfCBA/WXsH5DbJI8vwuuKPwNKieNEprIvL9NR5ahfw5xYYvaC2EpLBqMgIMHotwMQIDAQAB",
			},
		},
        content =
        {
            antialias = true,
            fps = 60,
            width = 320,
            height = 568,
            scale = "letterBox",
        --    xAlign = "center",
        --    yAlign = "center",
            imageSuffix = 
            {
                ["@2x"] = 1.5,
                ["@4x"] = 3.0
            },
        },
        notification = 
        {
            iphone = {
                types = {
                    "badge", "sound", "alert"
                }
            },
            google =
        {
                projectNumber = "xxxx",
         },
        }
    }

elseif string.sub(system.getInfo("model"),1,2) == "iP" then
    application = 
    {
		license =
		{
			google =
			{
				key = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwDhhCQu2eHQ0eA2M2y7yLDmF5AMO2N1GjEBn+hSCN6guc5QS2uR8IRPlwg1CDZ/DwjYwZ6fgpCJjHRl/GVxrAmzYC7cPhdJ29i4ppSEzAi8SxBKa3IwSZlzi64lWqr5NRbrfmc0mZjrQUTcHpRpdUjn9/TJIaa41LM7xyVnPAT/krqhwIwsURmTfGJRmCzxZI8+Xr2hZgOuyDWptE7mmCS0vVMQsnPATlmgiCnJOQythiap7Qr+2s6giupWWaF/1UYGB/EudvcdDPE4DN/mEBUfCBA/WXsH5DbJI8vwuuKPwNKieNEprIvL9NR5ahfw5xYYvaC2EpLBqMgIMHotwMQIDAQAB",
			},
		},
        content =
        {
            antialias = true,
            fps = 60,
            width = 320,
            height = 480,
            scale = "letterBox",
          --  xAlign = "center",
          --  yAlign = "center",
            imageSuffix = 
            {
                ["@2x"] = 1.5,
                ["@4x"] = 3.0,
            },
        },
        notification = 
        {
            iphone = {
                types = {
                    "badge", "sound", "alert"
                }
            },
            google =
        {
                projectNumber = "xxxx",
         },
        }
    }
elseif display.pixelHeight / display.pixelWidth > 1.72 then
    application = 
    {
		license =
		{
			google =
			{
				key = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwDhhCQu2eHQ0eA2M2y7yLDmF5AMO2N1GjEBn+hSCN6guc5QS2uR8IRPlwg1CDZ/DwjYwZ6fgpCJjHRl/GVxrAmzYC7cPhdJ29i4ppSEzAi8SxBKa3IwSZlzi64lWqr5NRbrfmc0mZjrQUTcHpRpdUjn9/TJIaa41LM7xyVnPAT/krqhwIwsURmTfGJRmCzxZI8+Xr2hZgOuyDWptE7mmCS0vVMQsnPATlmgiCnJOQythiap7Qr+2s6giupWWaF/1UYGB/EudvcdDPE4DN/mEBUfCBA/WXsH5DbJI8vwuuKPwNKieNEprIvL9NR5ahfw5xYYvaC2EpLBqMgIMHotwMQIDAQAB",
			},
		},
        content =
        {
            antialias = true,
            fps = 60,
            width = 320,
            height = 570,
            scale = "letterBox",
           -- xAlign = "center",
           -- yAlign = "center",
            imageSuffix = 
            {
                ["@2x"] = 1.5,
                ["@4x"] = 3.0,
            },
        },
    }
else
    application = 
    {
		license =
		{
			google =
			{
				key = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwDhhCQu2eHQ0eA2M2y7yLDmF5AMO2N1GjEBn+hSCN6guc5QS2uR8IRPlwg1CDZ/DwjYwZ6fgpCJjHRl/GVxrAmzYC7cPhdJ29i4ppSEzAi8SxBKa3IwSZlzi64lWqr5NRbrfmc0mZjrQUTcHpRpdUjn9/TJIaa41LM7xyVnPAT/krqhwIwsURmTfGJRmCzxZI8+Xr2hZgOuyDWptE7mmCS0vVMQsnPATlmgiCnJOQythiap7Qr+2s6giupWWaF/1UYGB/EudvcdDPE4DN/mEBUfCBA/WXsH5DbJI8vwuuKPwNKieNEprIvL9NR5ahfw5xYYvaC2EpLBqMgIMHotwMQIDAQAB",
			},
		},
        content =
        {
            antialias = true,
            fps = 60,
            width = 320,
            height = 512,
            scale = "letterBox",
            --xAlign = "center",
            --yAlign = "center",
            imageSuffix = 
            {
                ["@2x"] = 1.5,
                ["@4x"] = 3.0,
            },
        },
        notification = 
        {
            iphone = {
                types = {
                    "badge", "sound", "alert"
                }
            },
            google =
        {
                projectNumber = "xxxx",
         },
        }
    }
end