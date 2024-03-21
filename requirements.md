# Problem Statement

*An investment company (Acquisition Co) has been buying a few fast-food brands to build up a portfolio of companies, staff, sales, locations, and stock. They are looking to build a system that can be used to add / remove / update details about the brands they have acquired. Propose an enhanced entity relationship model showing the conceptual design for a database system based on the following details given to you from Acquisition Co.*

*Be sure to include Entities, attributes, primary identifiers (where they exist), associations, inheritance relationships, and cardinalities / constraints in your model where needed. Where there are ambiguities, be sure to include assumptions and outline how they impact the model. Acquisition Co only wants to store current information and does not want to store historical data in this this system.*

**Food Chain Company**: A food chain company is a company that Acquisition Co owns and wants to be able to keep a track of. The details they care about are the date they bought the company, the amount they bought the company for, the company name, and a unique company identifier assigned by Acquisition Co. Each company may have many physical stores. Each store would have a unique id assigned by Acquisition Co but might also have another unique identifier assigned by the company itself. The companies that are acquired may have used the same identifier scheme or different schemes to other acquired companies.

**Shopping Centre locations and other locations** : Each store may exist at a location, but a location may or may not be part of a larger shopping centre. So, for instance shop 5 and shop 7 in the Macquarie Shopping Centre are two different locations, but both part of the same shopping centre. The location details should include the address of the location, the size of the location (in square metres), and whether it has seating or is a takeaway only location. Acquisition Co would use their own location identifiers. For shopping centres, the details should include the name of the shopping centre, the phone number of the security office and the phone number and name of the centre manager. A location must be associated with at least one store, but a store must be associated with only one location.

**Product**: Part of the interest in managing all this data is to be able to work out the different types of products that each food chain has on offer for their customers. The types of products that Acquisition Co care about for this system are as follows: Food Items, Drink Items, Sundry Items (non-consumable items like an enviro reusable drink cup).

The details of ALL products must include a unique identifier assigned by Acquisition Co, a product name (which might be the same as another product name from other chains), sale price, cost price, and description. For food items, they need to include the details from all products and include details of the size, weight, if it is vegan or not, and if it is vegetarian or not. Drink items need to include the details from all products and include information about if it is a hot, cold, or room-temperature drink. Sundry would also need to include all the product details but need to also include details of product weight.

Acquisition Co also care about bundle products that may be on offer. So a bundle can be another type of product which would be a combination of other product types with an overall combined price discount to be applied to the sum of the products. Some example bundle scenarios might be 2 of the same food item, or a meal combo which includes food and drink items, … this needs to be flexible enough to adapt to any combination of food, drink, and or sundry items.

**Staff and Contracts**: Acquisition Co would like to keep a track of current staff across all stores and chains. These staff may be hired on various contracts with different stores, or a contract might cover a number of stores. A unique person ID will be assigned by Acquisition Co, but there may be other store-specific identifiers used as part of a contract for a staff member. A staff member might also be working with multiple chains, so this needs to be able to be captured in the system, but only 1 staff ID should exist per person. A contract might be a full time, part time, or casual contract. A full-time contract would have a start date, a salary, and the amount to be paid into their superannuation each year. The part time contract would include the start date, and the agreed number of hours per week, and the hourly pay rate and superannuation amount. The casual rate includes the start date, a base pay rate, and a loading % to be paid on top of the base pay rate.

A staff member may also be a manager for store; however this is to be captured separately from any contract details stored in the system. The manager details include start date, contact number, email, and the date of their next scheduled performance review.

**Sales**: While Acquisition Co does care about sales, it does not care about customer data or stock levels for this system. The sales data for this system should include a unique sale ID (provided by Acquisition Co) and other details like the time and date of purchase, the total amount paid, and the total tax for the sale. A sale may have been for one product or for many products, so a sale could have many sale items associated with it. However, each sale item should only refer to one product (and not multiple products), the notion of a bundle is to be considered as a single product for purposes of capturing sale items. A sale may have a discount $ amount applied to the sale, but individual sale items might also have individual discounts applied. A sale may or may not be associated with a staff member.