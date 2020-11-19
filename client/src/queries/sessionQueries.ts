import { gql } from "@apollo/client";

export const ME_FIELDS = gql`
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
  ${ME_FIELDS}
`;

export const LOGIN_MUTATION = gql`
  mutation Login($email: String!, $password: String!) {
    login(input: { email: $email, password: $password }) {
      me {
        ...MeFields
      }
    }
  }
  ${ME_FIELDS}
`;

export const LOGOUT_MUTATION = gql`
  mutation Logout {
    logout(input: {}) {
      clientMutationId
    }
  }
`;
