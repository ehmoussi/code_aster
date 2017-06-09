! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
! This file is part of code_aster.
!
! code_aster is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! code_aster is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
! --------------------------------------------------------------------

subroutine arltem(ndim  ,nomte, &
    nns   ,jcoors, &
    npgs  ,ivfs  ,idfdes,ipoids, &
    elref1,ndml1   ,jcoor1, &
    elref2,ndml2   ,jcoor2, &
    mcpln1,mcpln2)






    implicit none
#include "jeveux.h"
#include "asterfort/jevech.h"
#include "asterfort/arlmas.h"
#include "asterfort/arlt1d.h"
#include "asterfort/arlten.h"
#include "asterfort/arlted.h"


    integer :: ndim
    character(len=16) :: nomte
    integer :: nns,npgs
    integer :: ivfs,ipoids,idfdes
    character(len=8) :: elref1,elref2
    integer :: ndml1,jcoor1,jcoors
    integer :: ndml2,jcoor2
    real(kind=8) ::  mcpln1(2*ndim*ndml2,ndim*ndml1)
    real(kind=8) ::  mcpln2(2*ndim*ndml2,2*ndim*ndml2),mlv(78)

! ----------------------------------------------------------------------
!
! CALCUL DES MATRICES DE COUPLAGE ARLEQUIN (OPTION ARLQ_MATR)
! CALCUL DES INTEGRALES DE COUPLAGE ENTRE MAILLE 1 ET MAILLE 2
! SUR MAILLE SUPPORT S
!
! ----------------------------------------------------------------------


! IN  NDIM   : DIMENSION DU PROBLEME
! IN  NOMTE  : NOM DU TYPE_ELEMENT MAILLE SUPPORT S
! IN  NNS    : NOMBRE DE NOEUDS DE LA MAILLE SUPPORT S
! IN  NPGS   : NOMBRE DE POINTS DE GAUSS DE LA MAILLE SUPPORT S
! IN  IVFS   : POINTEUR VERS FONCTIONS DE FORME DE LA MAILLE SUPPORT S
! IN  IDFDES : POINTEUR VERS DER. FONCTIONS DE FORME DE LA MAILLE S
! IN  IPOIDS : POINTEUR VERS POIDS DE GAUSS DE LA MAILLE SUPPORT S
! IN  ELREFC : ELREFE DE LA MAILLE C
! IN  NNC    : NOMBRE DE NOEUDS DE LA MAILLE C
! IN  JCOORC : POINTEUR VERS COORD. NOEUDS DE LA MAILLE C
! OUT MCPLN1 : MATRICE DES TERMES DE COUPLAGE NST.NS
!              MATRICE CARREE (NNSxNNS)
! OUT MCPLN2 : MATRICE DES TERMES DE COUPLAGE NST.NC
!              MATRICE RECTANGULAIRE (NNSxNDML1)
! ----------------------------------------------------------------------

    real(kind=8) ::  poijcs(npgs)
    real(kind=8) ::  fcpig1(npgs*ndim*ndim*ndml1)
    real(kind=8) ::  dfdx1(npgs*ndim*ndim*ndml1)
    real(kind=8) ::  dfdy1(npgs*ndim*ndim*ndml1)
    real(kind=8) ::  dfdz1(npgs*ndim*ndim*ndml1)
    integer :: jinfor
    real(kind=8) ::  e, rho, xnu

! ----------------------------------------------------------------------

! --- CALCUL DES FF ET DES DERIVEES DES FF DES MAILLES COUPLEES


    call jevech('PINFORR','L',jinfor)

    e   = zr(jinfor+6-1)
    rho = 1.d0
    xnu = zr(jinfor+8-1)
    call arlmas('MECA_POU_D_T',e,xnu,rho,1,mlv)
    call arlt1d(mlv,ndim,ndml2,mcpln2)

    if ((nomte(1:9) == 'MECA_HEXA').or.(nomte(1:10) == 'MECA_PENTA') & 
                                   .or.(nomte(1:10) == 'MECA_TETRA')) then
        call arlted(ndim  , &
                    nns   ,jcoors, &
                    npgs  ,ivfs  , idfdes, ipoids, &
                    elref1, ndml1   ,jcoor1, &
                    fcpig1, poijcs, &
                    dfdx1, dfdy1 , dfdz1 )
        call arlten(zr(jcoor1)     ,zr(jcoor2), npgs, ndim , poijcs , &
                    ndml1 , ndml2 , fcpig1 , dfdx1 , dfdy1 , dfdz1 , &
                    mcpln1)
    endif

end subroutine
