import { gql } from "@apollo/client";

export const ME_FRAGMENT = gql`
  fragment MeFields on CurrentUser {
    displayName
    email
    bookRoles {
      book {
        id
        name
        createdAt
        owner {
          id
          email
          displayName
        }
      }
      role
      effectiveRoles
    }
  }
`;

export const ME_QUERY = gql`
  query Me {
    me {
      ...MeFields
    }
  }
  ${ME_FRAGMENT}
`;

export const LOGIN_MUTATION = gql`
  mutation Login($email: String!, $password: String!) {
    login(input: { email: $email, password: $password }) {
      me {
        ...MeFields
      }
    }
  }
  ${ME_FRAGMENT}
`;

export const LOGOUT_MUTATION = gql`
  mutation Logout {
    logout(input: {}) {
      clientMutationId
    }
  }
`;
