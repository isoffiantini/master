openapi: 3.0.3
info:
  title: Zara Wishlist API v2
  description: API completa para gestión de wishlists con múltiples funcionalidades
  version: 2.0.0
  contact:
    name: Zara Ecommerce Team
    email: api@zara.com

servers:
  - url: https://api.zara.com/v2
    description: Production server
  - url: https://staging-api.zara.com/v2
    description: Staging server

components:
  securitySchemes:
    bearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT
  
  schemas:
    Error:
      type: object
      properties:
        code:
          type: string
        message:
          type: string
        details:
          type: string

    Product:
      type: object
      properties:
        id:
          type: string
          example: "prod_123456"
        name:
          type: string
          example: "VESTIDO MIDI SATINADO"
        price:
          type: object
          properties:
            current:
              type: number
              format: float
              example: 29.95
            original:
              type: number
              format: float
              example: 39.95
            currency:
              type: string
              example: "EUR"
        images:
          type: array
          items:
            type: string
            format: uri
          example: ["https://image1.jpg", "https://image2.jpg"]
        available:
          type: boolean
          example: true
        url:
          type: string
          format: uri
          example: "https://zara.com/vestido-midi-satinado"

    WishlistItem:
      type: object
      properties:
        id:
          type: string
          example: "wish_item_789"
        product:
          $ref: '#/components/schemas/Product'
        quantity:
          type: integer
          minimum: 1
          maximum: 10
          example: 1
        size:
          type: string
          example: "M"
        color:
          type: string
          example: "NEGRO"
        added_at:
          type: string
          format: date-time
          example: "2024-01-15T10:30:00Z"
        notes:
          type: string
          example: "Para cumpleaños de María"
          maxLength: 200

    Wishlist:
      type: object
      properties:
        id:
          type: string
          example: "wish_123"
        user_id:
          type: string
          example: "user_456"
        name:
          type: string
          example: "Lista de Boda"
          maxLength: 100
        description:
          type: string
          example: "Regalos para nuestra boda en junio"
          maxLength: 500
        is_public:
          type: boolean
          example: false
        share_url:
          type: string
          format: uri
          example: "https://zara.com/share/wish_abc123"
        share_token:
          type: string
          example: "abc123xyz"
        items:
          type: array
          items:
            $ref: '#/components/schemas/WishlistItem'
        items_count:
          type: integer
          example: 5
        max_items:
          type: integer
          example: 50
        created_at:
          type: string
          format: date-time
          example: "2024-01-10T15:20:00Z"
        updated_at:
          type: string
          format: date-time
          example: "2024-01-15T10:30:00Z"

    CreateWishlistRequest:
      type: object
      required:
        - name
      properties:
        name:
          type: string
          minLength: 1
          maxLength: 100
          example: "Mi Lista de Deseos"
        description:
          type: string
          maxLength: 500
          example: "Productos que me gustaría comprar pronto"
        is_public:
          type: boolean
          example: false

    UpdateWishlistRequest:
      type: object
      properties:
        name:
          type: string
          minLength: 1
          maxLength: 100
          example: "Lista Actualizada"
        description:
          type: string
          maxLength: 500
          example: "Descripción actualizada"
        is_public:
          type: boolean
          example: true

    AddItemToWishlistRequest:
      type: object
      required:
        - product_id
      properties:
        product_id:
          type: string
          example: "prod_123456"
        quantity:
          type: integer
          minimum: 1
          maximum: 10
          default: 1
          example: 2
        size:
          type: string
          example: "M"
        color:
          type: string
          example: "NEGRO"
        notes:
          type: string
          maxLength: 200
          example: "Talla M en negro"

    UpdateWishlistItemRequest:
      type: object
      properties:
        quantity:
          type: integer
          minimum: 1
          maximum: 10
          example: 3
        size:
          type: string
          example: "L"
        color:
          type: string
          example: "AZUL"
        notes:
          type: string
          maxLength: 200
          example: "Cambiar a talla L"

    ShareWishlistResponse:
      type: object
      properties:
        share_url:
          type: string
          format: uri
          example: "https://zara.com/share/abc123"
        share_token:
          type: string
          example: "abc123"
        expires_at:
          type: string
          format: date-time
          example: "2024-02-15T23:59:59Z"

    ExportToCartRequest:
      type: object
      properties:
        item_ids:
          type: array
          items:
            type: string
          example: ["item_123", "item_456"]
        export_all:
          type: boolean
          example: true

    ExportToCartResponse:
      type: object
      properties:
        exported_items:
          type: integer
          example: 5
        failed_items:
          type: integer
          example: 0
        cart_items:
          type: array
          items:
            type: string
          example: ["cart_123", "cart_456"]

    WishlistMetrics:
      type: object
      properties:
        total_wishlists:
          type: integer
          example: 15000
        active_wishlists:
          type: integer
          example: 12000
        total_items:
          type: integer
          example: 45000
        avg_items_per_wishlist:
          type: number
          format: float
          example: 3.0
        most_popular_products:
          type: array
          items:
            type: object
            properties:
              product_id:
                type: string
              product_name:
                type: string
              wishlist_count:
                type: integer
        shared_wishlists_count:
          type: integer
          example: 2500
        conversion_rate:
          type: number
          format: float
          example: 0.15

    ApiResponse:
      type: object
      properties:
        success:
          type: boolean
        data:
          type: object
        message:
          type: string

paths:
  # =============================================
  # WISHLIST MANAGEMENT - CRUD
  # =============================================
  /wishlists:
    post:
      summary: Crear nueva wishlist
      description: Crea una nueva wishlist con nombre, descripción y configuración
      security:
        - bearerAuth: []
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CreateWishlistRequest'
      responses:
        '201':
          description: Wishlist creada exitosamente
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ApiResponse'
              example:
                success: true
                message: "Wishlist creada exitosamente"
                data:
                  wishlist_id: "wish_123"
        '400':
          description: Solicitud inválida
        '409':
          description: Límite de wishlists alcanzado

    get:
      summary: Obtener todas las wishlists del usuario
      description: Retorna todas las wishlists del usuario autenticado
      security:
        - bearerAuth: []
      responses:
        '200':
          description: Wishlists obtenidas exitosamente
          content:
            application/json:
              schema:
                type: object
                properties:
                  wishlists:
                    type: array
                    items:
                      $ref: '#/components/schemas/Wishlist'
                  total_count:
                    type: integer

  /wishlists/{wishlist_id}:
    get:
      summary: Obtener wishlist específica
      description: Retorna una wishlist específica con todos sus items
      security:
        - bearerAuth: []
      parameters:
        - name: wishlist_id
          in: path
          required: true
          schema:
            type: string
      responses:
        '200':
          description: Wishlist obtenida exitosamente
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Wishlist'
        '404':
          description: Wishlist no encontrada

    put:
      summary: Actualizar wishlist
      description: Actualiza el nombre, descripción y configuración de una wishlist
      security:
        - bearerAuth: []
      parameters:
        - name: wishlist_id
          in: path
          required: true
          schema:
            type: string
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/UpdateWishlistRequest'
      responses:
        '200':
          description: Wishlist actualizada exitosamente
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ApiResponse'

    delete:
      summary: Eliminar wishlist
      description: Elimina permanentemente una wishlist y todos sus items
      security:
        - bearerAuth: []
      parameters:
        - name: wishlist_id
          in: path
          required: true
          schema:
            type: string
      responses:
        '200':
          description: Wishlist eliminada exitosamente
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ApiResponse'
              example:
                success: true
                message: "Wishlist eliminada con 5 productos"

  # =============================================
  # WISHLIST SHARING
  # =============================================
  /wishlists/{wishlist_id}/share:
    post:
      summary: Compartir wishlist
      description: Genera una URL corta para compartir la wishlist
      security:
        - bearerAuth: []
      parameters:
        - name: wishlist_id
          in: path
          required: true
          schema:
            type: string
      responses:
        '200':
          description: URL de compartir generada exitosamente
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ShareWishlistResponse'

    delete:
      summary: Desactivar compartir wishlist
      description: Invalida la URL de compartir existente
      security:
        - bearerAuth: []
      parameters:
        - name: wishlist_id
          in: path
          required: true
          schema:
            type: string
      responses:
        '200':
          description: Compartir desactivado exitosamente
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ApiResponse'

  /wishlists/shared/{share_token}:
    get:
      summary: Obtener wishlist compartida
      description: Obtiene una wishlist compartida usando el token (sin autenticación)
      parameters:
        - name: share_token
          in: path
          required: true
          schema:
            type: string
      responses:
        '200':
          description: Wishlist compartida obtenida exitosamente
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Wishlist'
        '404':
          description: Wishlist no encontrada o enlace expirado

  # =============================================
  # WISHLIST ITEMS MANAGEMENT
  # =============================================
  /wishlists/{wishlist_id}/items:
    post:
      summary: Añadir item a wishlist
      description: Añade un producto a la wishlist (máximo 50 items por wishlist)
      security:
        - bearerAuth: []
      parameters:
        - name: wishlist_id
          in: path
          required: true
          schema:
            type: string
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/AddItemToWishlistRequest'
      responses:
        '201':
          description: Item añadido exitosamente
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ApiResponse'
              example:
                success: true
                message: "Producto añadido a la wishlist"
                data:
                  item_id: "item_123"
                  current_count: 15
        '400':
          description: Límite de 50 items alcanzado
        '409':
          description: Producto ya existe en la wishlist

    get:
      summary: Obtener items de wishlist
      description: Retorna todos los items de una wishlist específica
      security:
        - bearerAuth: []
      parameters:
        - name: wishlist_id
          in: path
          required: true
          schema:
            type: string
      responses:
        '200':
          description: Items obtenidos exitosamente
          content:
            application/json:
              schema:
                type: object
                properties:
                  items:
                    type: array
                    items:
                      $ref: '#/components/schemas/WishlistItem'
                  total_count:
                    type: integer

    delete:
      summary: Eliminar todos los items de la wishlist
      description: Vacía completamente la wishlist pero la mantiene activa
      security:
        - bearerAuth: []
      parameters:
        - name: wishlist_id
          in: path
          required: true
          schema:
            type: string
      responses:
        '200':
          description: Todos los items eliminados exitosamente
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ApiResponse'
              example:
                success: true
                message: "15 productos eliminados de la wishlist"

  /wishlists/{wishlist_id}/items/{item_id}:
    put:
      summary: Actualizar item de wishlist
      description: Modifica cantidad, talla, color o notas de un item
      security:
        - bearerAuth: []
      parameters:
        - name: wishlist_id
          in: path
          required: true
          schema:
            type: string
        - name: item_id
          in: path
          required: true
          schema:
            type: string
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/UpdateWishlistItemRequest'
      responses:
        '200':
          description: Item actualizado exitosamente
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ApiResponse'

    delete:
      summary: Eliminar item específico de wishlist
      description: Elimina un producto específico de la wishlist
      security:
        - bearerAuth: []
      parameters:
        - name: wishlist_id
          in: path
          required: true
          schema:
            type: string
        - name: item_id
          in: path
          required: true
          schema:
            type: string
      responses:
        '200':
          description: Item eliminado exitosamente
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ApiResponse'

  # =============================================
  # EXPORT TO CART
  # =============================================
  /wishlists/{wishlist_id}/export-to-cart:
    post:
      summary: Exportar items al carrito
      description: Exporta uno, varios o todos los items de la wishlist al carrito
      security:
        - bearerAuth: []
      parameters:
        - name: wishlist_id
          in: path
          required: true
          schema:
            type: string
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/ExportToCartRequest'
      responses:
        '200':
          description: Items exportados al carrito exitosamente
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ExportToCartResponse'

  # =============================================
  # METRICS & ANALYTICS
  # =============================================
  /wishlists/metrics:
    get:
      summary: Obtener métricas de wishlists
      description: Endpoint para métricas agregadas de uso de wishlists
      security:
        - bearerAuth: []
      parameters:
        - name: start_date
          in: query
          schema:
            type: string
            format: date
          description: Fecha de inicio para el reporte
        - name: end_date
          in: query
          schema:
            type: string
            format: date
          description: Fecha de fin para el reporte
        - name: metric_type
          in: query
          schema:
            type: string
            enum: [usage, conversion, popular_products]
          description: Tipo de métrica a obtener
      responses:
        '200':
          description: Métricas obtenidas exitosamente
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/WishlistMetrics'

  /wishlists/{wishlist_id}/metrics:
    get:
      summary: Obtener métricas de wishlist específica
      description: Métricas detalladas para una wishlist específica
      security:
        - bearerAuth: []
      parameters:
        - name: wishlist_id
          in: path
          required: true
          schema:
            type: string
      responses:
        '200':
          description: Métricas obtenidas exitosamente
          content:
            application/json:
              schema:
                type: object
                properties:
                  view_count:
                    type: integer
                    example: 150
                  share_count:
                    type: integer
                    example: 25
                  conversion_count:
                    type: integer
                    example: 8
                  most_viewed_items:
                    type: array
                    items:
                      $ref: '#/components/schemas/WishlistItem'