//
//  ConstantsUrl.swift
//  Katfa
//
//  Created by Elattar on 7/15/20.
//  Copyright © 2020 Elattar. All rights reserved.
//

import Foundation

class URLs{
    
     static let main = "https://Pomac.info/ward/public/api/"
    
    
    static let homeData: (_ lat: Double,_ long: Double) -> String = { lat, long in
       return main + "home?user_lat=\(lat)&user_lng=\(long)"
    }

    static let seeMore = main + "home/search-products?selling=1"
    static let storeProduct: (_ storeID: Int) -> String = { storeID in
        return main + "home/search-products?store_id=\(storeID)"
    }
    static let seeMoreCategory: (_ id: String) -> String = { id in
        main + "subcategories?category_id[0]=\(id)"
    }
    static let RecommendationProducts: (_ storeID: String) -> String = { storeID in
        main + "home/recommendations?store_id=\(storeID)"
    }
    static let showProductsByCategoryIdAndSubcategoryId: (_ category_id: String,_ subcategory_id: String) -> String = { category_id, subcategory_id in
        main + "products/show-products-by-category-subcategory-id?category_id=\(category_id)&subcategory_id=\(subcategory_id)"
    }
    static let register = main + "client-users/register"
    static let login = main + "users/login"
    static let addToCart = main + "carts/create"
    static let wishlist = main + "wishlists/create"
    static let deleteFromWishlist: (_ id: Int) -> String = { id in
        return main + "wishlists/delete?product_id=\(id)"
    }
    static let deleteSellerFromWishlist: (_ id: Int) -> String = { id in
        return main + "favorite-sellers/delete?store_id=\(id)"
    }
    static let sellerTowishlist = main + "favorite-sellers/create"
    static let size = main + "sizes"
    static let cart = main + "carts/show"
    static let updateQuantity = main + "carts/update"
    static let checkAddressFee: (_ storeID: Int) -> String = { id in
        return main + "checkout?store_id=\(id)"
    }
    static let deleteCartItem: (_ cartItemId: Int) -> String = { id in
        return main + "carts/delete?cart_item_id=\(id)"
    }
    static let addAddress = main + "address/create"
    static let createOrder = main + "order/create"
    static let order = main + "orders/show"
    static let cancelOrder: (_ order_id: Int) -> String = { id in
        return main + "order/cancel?order_id=\(id)"
    }
    static let getAddresses = main + "addresses/show"
    static let wishlistShow = main + "wishlists/show"
    static let setDefaultAddress = main + "address/set-default"
    static let changePassword = main + "users/update-password"
    static let updateProfile = main + "users/update-profile"
    static let wishlistSellerShow = main + "favorite-sellers/show"
    static let forgetPassword = main + "users/reset_password"
}
