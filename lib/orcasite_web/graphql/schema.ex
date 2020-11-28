defmodule OrcasiteWeb.Schema do
  use Absinthe.Schema

  import_types(Absinthe.Type.Custom)
  import_types(OrcasiteWeb.Types.{JSON, Account, Feed, Detection, Pagination})

  alias OrcasiteWeb.Resolvers

  query do
    @desc "Get logged in user"
    field(:current_user, :user, resolve: &Resolvers.Accounts.current_user/2)

    @desc "Get a list of feeds"
    field(:feeds, list_of(:feed), resolve: &Resolvers.Feed.index/2)

    @desc "Get a feed"
    field :feed, :feed do
      arg(:slug, :string)

      resolve(&Resolvers.Feed.show/2)
    end

    #@desc "List detections"
    #field :detections, list_of(:detection) do
    #  resolve(&Resolvers.Detection.index/2)
    #end

     # TODO: fix what happens if an admin is logged in and tries to list the detections
     @desc "List detections from feed, paginated"
     field :get_detections_for_feed, list_of(:detection) do
       # arg(:pagination, :pagination)
       arg(:slug, :string)
       resolve(&Resolvers.Detection.list_detections_for_feed/2)
     end

    # TODO: fix what happens if an admin is logged in and tries to list the detections
    @desc "List detections, paginated"
    field :detections, list_of(:detection) do
      arg(:pagination, :pagination)
      resolve(&Resolvers.Detection.list_detections/2)
    end

    @desc "List candidates, paginated"
    field :candidates, :candidates do
      arg(:pagination, :pagination)
      resolve(&Resolvers.Detection.list_candidates/2)
    end

    @desc "List users, paginated"
    field :users, :users do
      arg(:pagination, :pagination)
      resolve(&Resolvers.Accounts.list_users/2)
    end
  end

  mutation do
    @desc "Create user"
    field :signup, :user do
      arg(:first_name, :string)
      arg(:last_name, :string)
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))

      resolve(&Resolvers.Accounts.create_user/2)
    end

    @desc "Log in"
    field :login, :user do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))

      resolve(&Resolvers.Accounts.login/2)
    end

    @desc "Log out"
    field :logout, :user do
      arg(:id)
      resolve(&Resolvers.Accounts.logout/2)
    end

    @desc "Update user details"
    field :update_user, :user do
      arg(:id)
      arg(:admin, :boolean)
      resolve(&Resolvers.Accounts.update_user/2)
    end

    @desc "Submit an orca sound detection"
    field :submit_detection, :detection_with_lockout do
      arg(:feed_id, :id)
      arg(:playlist_timestamp, :string)
      arg(:player_offset, :decimal)
      arg(:type, :string)
      arg(:description, :string)

      resolve(&Resolvers.Detection.create/2)
    end
  end
end
