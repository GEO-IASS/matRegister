function test_suite = test_Translation(varargin) %#ok<STOUT>
%TEST_TRANSLATION  Test function for class Translation
%   output = test_Translation(input)
%
%   Example
%   test_Translation
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-06-03,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


initTestSuite;

function testEmptyConstructor %#ok<*DEFNU>

% test empty constructor
trans = Translation();
assertTrue(trans.isvalid());

function testConstructor2D

% test constructor with separate arguments
trans = Translation(2, 3);
assertTrue(trans.isvalid());

% test constructor with bundled arguments
trans = Translation([2, 3]);
assertTrue(trans.isvalid());

% test copy constructor
trans2 = Translation(trans);
assertTrue(trans2.isvalid());

function testConstructor3D

% test constructor with separate arguments
trans = Translation(2, 3, 4);
assertTrue(trans.isvalid());

% test constructor with bundled arguments
trans = Translation([2, 3, 4]);
assertTrue(trans.isvalid());

% test copy constructor
trans2 = Translation(trans);
assertTrue(trans2.isvalid());


function testIsa

trans = Translation([2 3]);
assertTrue(isa(trans, 'Transform'));
assertTrue(isa(trans, 'AffineTransform'));


