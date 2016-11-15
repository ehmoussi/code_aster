!> Returns the supervisor type name of the result.

!> The type name is the name of the Python class in uppercases.
!>
!> It returns ' ' if the datastructure has not been registered.

!> @param[in]  name     Name of the datastructure
!> @param[out] typeco   Name of the supervisor type.
!> @param[in]  errstop  Interrupt the execution if the type is unknown (optional).

subroutine gettco(name, typeco, errstop)
! ======================================================================
! COPYRIGHT (C) 1991 - 2016  EDF R&D                  WWW.CODE-ASTER.ORG
! THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
! IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
! THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
! (AT YOUR OPTION) ANY LATER VERSION.
!
! THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
! WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
! MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
! GENERAL PUBLIC LICENSE FOR MORE DETAILS.
!
! YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
! ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
!   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
! ======================================================================
! person_in_charge: mathieu.courtois@edf.fr

    implicit none

#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/gettc2.h"

!   arguments
    character(len=*), intent(in) :: name
    character(len=*), intent(out) :: typeco
    aster_logical, intent(in), optional :: errstop

    call gettc2(name, typeco)

end subroutine gettco
